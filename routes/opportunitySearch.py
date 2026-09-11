

from flask import app, render_template, request, redirect, make_response
# from dbQueries import
import os
from dotenv import load_dotenv
import mysql.connector
import shlex
from flashtext import KeywordProcessor

from routes import opportunities


load_dotenv() # load environment variables from .env file

#1b. initialize the database connection
def get_db_connection():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME"),
        port=int(os.getenv("DB_PORT", 3306)) # Optional: Good practice to include the port, with a default value of 3306 for MySQL
   )

# Set up a keyword processor for search intent tokenizing
keyword_processor = KeywordProcessor()

def load_search_lexicon():
    conn = get_db_connection()
    mycursor = conn.cursor(buffered=True)
    # Load award types as attribute filters
    mycursor.execute("SELECT name, id FROM awardtype")
    for at_name, at_id in mycursor.fetchall():
        keyword_processor.add_keyword({"type": "awardtype", "id": at_id, "val": at_name.lower()})

    # Load stages as attribute filters
    mycursor.execute("SELECT name, id FROM stage")
    for stage_name, stage_id in mycursor.fetchall():
        keyword_processor.add_keyword({"type": "stage", "id": stage_id, "val": stage_name.lower()})

    # Load fields as attribute filters
    mycursor.execute("SELECT name, id FROM field")
    for field_name, field_id in mycursor.fetchall():
        keyword_processor.add_keyword({"type": "field", "id": field_id, "val": field_name.lower()})

    # Load nationalities as attribute filters
    mycursor.execute("SELECT name, id FROM nationality")
    for nationality_name, nationality_id in mycursor.fetchall():
        keyword_processor.add_keyword({"type": "nationality", "id": nationality_id, "val": nationality_name.lower()})

    #Load departments as phrases
    mycursor.execute("SELECT name FROM department")
    for (department_name,) in mycursor.fetchall():
        if department_name:  # Ensure the department name is not None or empty
            keyword_processor.add_keyword({"type": "text_phrase", "val": department_name.lower()})

    #Load programs as phrases
    mycursor.execute("SELECT name FROM program")
    for (program_name,) in mycursor.fetchall():
        if program_name:  # Ensure the program name is not None or empty
            keyword_processor.add_keyword({"type": "text_phrase", "val": program_name.lower()})

    mycursor.close()
    conn.close()
# call the function to load the search lexicon when the application starts
try:
    load_search_lexicon()  
except Exception as e:
    print(f"Error loading search lexicon: {e}")

# Load the main page; populate filter panel with all opportunity attributes (award types, stages, fields, nationalities) and render the home page
def init_customer_home_route(app):
    @app.route('/', methods=['GET', 'POST'])
    def customer_home():
        conn = None
        mycursor = None
        try:
            conn = get_db_connection()
            mycursor = conn.cursor(buffered=True)
            mycursor.execute("SELECT * FROM awardtype ORDER BY name ASC")
            allAwardTypes = mycursor.fetchall()
            mycursor.execute("SELECT * FROM stage")
            allStages = mycursor.fetchall()
            mycursor.execute("SELECT * FROM field ORDER BY name ASC")
            allFields = mycursor.fetchall()
            mycursor.execute("SELECT * FROM nationality")
            allNationalities = mycursor.fetchall()
            return render_template('customer/home.html', allAwardTypes=allAwardTypes, allStages=allStages, allFields=allFields, allNationalities=allNationalities)
        except mysql.connector.Error as err:
            print(f"Error: {err}")
            return "A database error occurred. Please try again later.", 500
        finally:
            if mycursor:
                try: mycursor.close()
                except: pass
            if conn and conn.is_connected():
                try: conn.close()
                except: pass



def init_opportunity_search_results_route(app):
    @app.route('/opportunity-search-results', methods=['GET', 'POST'])
    def opportunity_search_results():
        # Get the search query from the form submission    
        raw_query = request.form.get('opportunitySearchTerm', '').strip()
        query_lower = raw_query.lower()

        # check if the filter menu has been submitted, and pull the awardtype list from there. If not, pull the awardtype list from the search form. If neither, then just do a search with no filters.
        rawAwardTypes = request.form.getlist('awardType')
        filteredAwardTypes = [int(x) for x in set(rawAwardTypes) if x and x != 'all']   # deduplicate the list of award types to avoid duplicates in the SQL query

        # Use FlashText to scan the raw query string for multi-word phrases that match known award types, stages, fields, nationalities, departments, or programs. This allows for more accurate parsing of the search intent.
        extracted_keywords = keyword_processor.extract_keywords(query_lower)
        filteredStages = []
        filteredFields = []
        filteredNationalities = []
        extracted_phrases = []

        # Track words that were recognized as specific filters or phrases, and remove them from the search query to avoid redundancy in the search.
        facet_words_to_remove = set()

        for match in extracted_keywords:
            if match["type"] == "awardtype" and match["id"] not in filteredAwardTypes:
                filteredAwardTypes.append(match["id"])
                facet_words_to_remove.add(match["val"])  # Add the matched award type to the set of words to remove from the search query
                print("FILTERED AWARD TYPES: ", filteredAwardTypes)  # Debugging line to print the filtered award types
            elif match["type"] == "stage" and match["id"] not in filteredStages:
                filteredStages.append(match["id"])
                facet_words_to_remove.add(match["val"])  # Add the matched stage to the set of words to remove from the search query
                print("FILTERED STAGES: ", filteredStages)  # Debugging line to print the filtered stages
            elif match["type"] == "field" and match["id"] not in filteredFields:
                filteredFields.append(match["id"])
                facet_words_to_remove.add(match["val"])  # Add the matched field to the set of words to remove from the search query
                print("FILTERED FIELDS: ", filteredFields)  # Debugging line to print the filtered fields
            elif match["type"] == "nationality" and match["id"] not in filteredNationalities:
                filteredNationalities.append(match["id"])
                facet_words_to_remove.add(match["val"])  # Add the matched nationality to the set of words to remove from the search query
                print("FILTERED NATIONALITIES: ", filteredNationalities)  # Debugging line to print the filtered nationalities
            elif match["type"] == "text_phrase":
                extracted_phrases.append(match["val"])  # Store the matched phrase for later use in the search query
                pass

        # Build a Boolean search payload for MySQL
        # If FlashText catches a program name like "computer science", wrap it in quotes.
        for phrase in facet_words_to_remove:
            query_lower = query_lower.replace(phrase, '')  # Remove recognized filter words from the search query
            print("QUERY_LOWER: ", query_lower)  # Debugging line to print the modified query after removing recognized filter words
        boolean_search_terms = [query_lower] + [f'"{phrase}"' for phrase in extracted_phrases if phrase not in facet_words_to_remove]  # Only include phrases that were not recognized as specific filters
        boolean_search_payload = ' '.join(boolean_search_terms)



        # Connect to the database and perform the search
        opportunities = []
        conn = None
        mycursor = None

        try:
                conn = get_db_connection()
                mycursor = conn.cursor(buffered=True)
                # Single query with multiple JOINs to grab names from related tables
                # Consider adding Description here or adding a modal to show more details when clicking on an opportunity
                query = """
                    SELECT
                        o.id,
                        o.name,
                        o.website,
                        org.name AS funding_agency,
                        org.logopath AS funding_agency_logo,
                        GROUP_CONCAT(DISTINCT at.name SEPARATOR ', ')  AS award_type
                    FROM opportunity o
                    LEFT JOIN organization org ON o.organization_id = org.id
                    LEFT JOIN awardtypeopportunity ato ON o.id = ato.opportunity_id
                    LEFT JOIN awardtype at ON ato.awardtype_id = at.id
                    WHERE (
                        MATCH(o.name) AGAINST (%s IN BOOLEAN MODE) OR
                        MATCH(o.description) AGAINST (%s IN BOOLEAN MODE) OR
                        MATCH(org.name) AGAINST (%s IN BOOLEAN MODE))
                    
                        """

                if filteredAwardTypes:
                    query += """ AND EXISTS (
                        SELECT 1 FROM awardtypeopportunity ato_sub
                        WHERE ato_sub.opportunity_id = o.id
                        AND ato_sub.awardtype_id IN ({})
                    )""".format(','.join(['%s'] * len(filteredAwardTypes)))

                if filteredStages:
                    query += """ AND EXISTS (
                        SELECT 1 FROM stageopportunity sto_sub
                        WHERE sto_sub.opportunity_id = o.id
                        AND sto_sub.stage_id IN ({})
                    )""".format(','.join(['%s'] * len(filteredStages)))

                if filteredFields:
                    query += """ AND EXISTS (
                        SELECT 1 FROM fieldopportunity fo_sub
                        WHERE fo_sub.opportunity_id = o.id
                        AND fo_sub.field_id IN ({})
                    )""".format(','.join(['%s'] * len(filteredFields)))

                if filteredNationalities:
                    query += """ AND EXISTS (
                        SELECT 1 FROM nationalityopportunity no_sub
                        WHERE no_sub.opportunity_id = o.id
                        AND no_sub.nationality_id IN ({})
                    )""".format(','.join(['%s'] * len(filteredNationalities)))

                query += " GROUP BY o.id, o.name, o.website, org.name, org.logopath"

                print("FINAL SQL QUERY:", query)  # Debugging line to print the final SQL query
                # print("FILTERED AWARD TYPES:", filteredAwardTypes)  # Debugging line to print the filtered award types
                # print("FILTERED STAGES:", filteredStages)  # Debugging line to print the filtered stages
                # print("FILTERED FIELDS:", filteredFields)  # Debugging line to print the filtered fields
                # print("FILTERED NATIONALITIES:", filteredNationalities)  # Debugging line to print the filtered nationalities


                mycursor.execute(query, (boolean_search_payload, boolean_search_payload, boolean_search_payload, *filteredAwardTypes, *filteredStages, *filteredFields, *filteredNationalities))
                matches = mycursor.fetchall()

                # Add a zero-results safety net (fallback in case search terms don't deliver any results)
                is_relaxed_search = False
                if not matches and (filteredAwardTypes or filteredStages or filteredFields or filteredNationalities):
                    is_relaxed_search = True
                    relaxed_query = """
                        SELECT
                            o.id,
                            o.name,
                            o.website,
                            org.name AS funding_agency,
                            org.logopath AS funding_agency_logo,
                            GROUP_CONCAT(DISTINCT at.name SEPARATOR ', ')  AS award_type
                        FROM opportunity o
                        LEFT JOIN organization org ON o.organization_id = org.id
                        LEFT JOIN awardtypeopportunity ato ON o.id = ato.opportunity_id
                        LEFT JOIN awardtype at ON ato.awardtype_id = at.id
                        WHERE (
                            MATCH(o.name) AGAINST (%s IN BOOLEAN MODE) OR
                            MATCH(o.description) AGAINST (%s IN BOOLEAN MODE) OR
                            MATCH(org.name) AGAINST (%s IN BOOLEAN MODE))
                        GROUP BY o.id, o.name, o.website, org.name, org.logopath
                    """
                    mycursor.execute(relaxed_query, (boolean_search_payload, boolean_search_payload, boolean_search_payload))
                    matches = mycursor.fetchall()


                try:
                    mycursor.close()
                except:
                    pass
                try:
                    conn.close()
                except:
                    pass

                # print("MATCHES FOUND:", matches)  # Debugging line to print the matches found

                for match in matches:
                    opportunityInfo = {
                        'name': match[1],
                        'funding_agency': match[3] if match[3] else 'Unknown',  # Handle case where funding agency might be NULL
                        'funding_agency_logo': match[4] if match[4] else 'Unknown',  # Handle case where funding agency logo might be NULL
                        'award_type': match[5] if match[5] else 'N/A',  # Handle case where award type might be NULL
                        'website': match[2],
                    }
                    # print(opportunityInfo)
                    opportunities.append(opportunityInfo)

                # Reconnect to the database to fetch all filter options for rendering the filter menu
                conn = get_db_connection()
                mycursor = conn.cursor(buffered=True)
                mycursor.execute("SELECT * FROM awardtype ORDER BY name ASC")
                allAwardTypes = mycursor.fetchall()
                mycursor.execute("SELECT * FROM stage")
                allStages = mycursor.fetchall()
                mycursor.execute("SELECT * FROM field ORDER BY name ASC")
                allFields = mycursor.fetchall()
                mycursor.execute("SELECT * FROM nationality")
                allNationalities = mycursor.fetchall()

                renderResults = render_template('customer/_searchResults.html', opportunities=opportunities, search_query=raw_query, allAwardTypes=allAwardTypes, allStages=allStages, allFields=allFields, allNationalities=allNationalities)
                renderFilterMenu = render_template('customer/_opportunitySearchFilters.html', allAwardTypes=allAwardTypes, allStages=allStages, allFields=allFields, allNationalities=allNationalities, filteredAwardTypes=filteredAwardTypes, filteredStages=filteredStages, filteredFields=filteredFields, filteredNationalities=filteredNationalities)

                #Wrap the filter menu in an element that targets the sidebar OOB and adds the visible class
                sidebar_response = f'<aside class="filters-sidebar visible" id="filters_sidebar" hx-swap-oob="true"><details class="mobile-filter-accordion" open><summary class="filter-toggle-btn">...</summary><div id="opportunity_search_filters">{renderFilterMenu}</div></details></aside>'
                return renderResults + sidebar_response

        except mysql.connector.Error as err:
            print(f"Error: {err}")
            return "A database error occurred while processing your search. Please try again later.", 500
        finally:
            if mycursor:
                try: mycursor.close()
                except: pass
            if conn and conn.is_connected():
                try: conn.close()
                except: pass