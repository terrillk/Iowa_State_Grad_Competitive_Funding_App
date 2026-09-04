

from flask import app, render_template, request, redirect, make_response
# from dbQueries import
import os
from dotenv import load_dotenv
import mysql.connector
import shlex

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
        try:
            search_terms = shlex.split(query_lower)  # Split the search query into individual terms, respecting quoted phrases
        except ValueError:
            # Handle the case where the search query has unmatched quotes
            search_terms = query_lower.split()  # Fallback to simple split if there's a ValueError


        # Get all the opportunity attribute lists from the database to deal with search intent parsing and to populate the filter menu
        conn = get_db_connection()
        mycursor = conn.cursor(buffered=True)
        mycursor.execute("SELECT * FROM awardtype")
        allAwardTypes = mycursor.fetchall()
        mycursor.execute("SELECT * FROM stage")
        allStages = mycursor.fetchall()
        mycursor.execute("SELECT * FROM field")
        allFields = mycursor.fetchall()
        mycursor.execute("SELECT * FROM nationality")
        allNationalities = mycursor.fetchall()
        mycursor.close()
        conn.close()

        # check if the filter menu has been submitted, and pull the awardtype list from there. If not, pull the awardtype list from the search form. If neither, then just do a search with no filters.
        rawAwardTypes = request.form.getlist('awardType')
        filteredAwardTypes = [int(x) for x in set(rawAwardTypes) if x and x != 'all']   # deduplicate the list of award types to avoid duplicates in the SQL query
        filteredStages = [int(x) for x in list(set(request.form.getlist('stage')))]
        filteredFields = [int(x) for x in list(set(request.form.getlist('field')))]
        filteredNationalities = [int(x) for x in list(set(request.form.getlist('nationality')))]

        # Parse the search intent by pulling out terms that match the award type, stage, field, and nationality
        for term in search_terms[:]:  # Iterate over a copy of the list to avoid modifying it while iterating
            for awardType in allAwardTypes:
                if term == awardType[0].lower():
                    search_terms.remove(term)
                    if awardType[1] not in filteredAwardTypes:
                        filteredAwardTypes.append(awardType[1])  # Add the ID of the matched award type to the filtered list
                    break  # Exit the inner loop once a match is found
            for stage in allStages:
                if term == stage[0].lower():
                    search_terms.remove(term)
                    if stage[1] not in filteredStages:
                        filteredStages.append(stage[1])  # Add the ID of the matched stage to the filtered list
                    break
            for field in allFields:
                if term == field[0].lower():
                    search_terms.remove(term)
                    if field[1] not in filteredFields:
                        filteredFields.append(field[1])  # Add the ID of the matched field to the filtered list
                    break
            for nationality in allNationalities:
                if term == nationality[0].lower():
                    search_terms.remove(term)
                    if nationality[1] not in filteredNationalities:
                        filteredNationalities.append(nationality[1])  # Add the ID of the matched nationality to the filtered list
                    break




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
                        MATCH(o.name) AGAINST (%s IN NATURAL LANGUAGE MODE) OR
                        MATCH(o.description) AGAINST (%s IN NATURAL LANGUAGE MODE) OR
                        MATCH(org.name) AGAINST (%s IN NATURAL LANGUAGE MODE))
                    
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


                mycursor.execute(query, (query_lower, query_lower, query_lower, *filteredAwardTypes, *filteredStages, *filteredFields, *filteredNationalities))
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