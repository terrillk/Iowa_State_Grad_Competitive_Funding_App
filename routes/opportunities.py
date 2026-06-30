from flask import app, render_template, request, redirect, make_response
# from dbQueries import
import os
from dotenv import load_dotenv
import mysql.connector


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

def sanitize_url(user_input):
    """
    Sanitizes a URL by ensuring it starts with http:// or https:// and removing any leading/trailing whitespace.
    """
    if not user_input:
        return None  # Return None for empty input
    
    cleaned_url = user_input.strip().lower()  # Remove leading/trailing whitespace and convert to lowercase
    if not cleaned_url.startswith(("http://", "https://")):
        cleaned_url = 'https://' + cleaned_url
         
    return cleaned_url  # Return the sanitized URL

def find_joined_attributes(cursor, opportunity_id, attribute_name):
    """
    generates a list of already joined attributes
    attribute_name is the name of the attribute, e.g., "awardtype", "stage", "field", or "nationality"

    """

    join_table = f"{attribute_name}opportunity"
    
    query = f"SELECT * FROM {join_table} WHERE opportunity_id = %s"
    cursor.execute(query, (opportunity_id,))
    return cursor.fetchall()


def init_manage_opportunities_route(app):
    @app.route('/manage-opportunity', methods=['GET', 'POST'])
    def manage_opportunities():
        selected_opportunity = "Select an opportunity"
        conn = get_db_connection()
        mycursor = conn.cursor()
        opportunities = mycursor.execute("SELECT name FROM Opportunity")
        opportunities = mycursor.fetchall() # fetchall() retrieves all rows of the query result and returns them as a list of tuples
        mycursor.close()    
        conn.close()

        """
        Check if the input opportunity is already in the database, and if not then create a new record in the database.
        """
        if request.method == 'POST':
            selected_opportunity = request.form.get('opportunity_name')     # grab the string from the <select> element

        return render_template('admin/manageOpportunity.html', opportunities=opportunities, selected_opportunity=selected_opportunity)
    
def init_opportunity_details_route(app):
    @app.route('/opportunity-details', methods=['GET','POST'])
    def opportunity_details():        
        opportunity_query = "SELECT * FROM opportunity WHERE name = %s" # define a query function that utilizes data from the HTML form
        
        conn = get_db_connection()
        mycursor = conn.cursor(buffered=True)
        current_opportunity_name = request.values.get('opportunity_name')
        mycursor.execute(opportunity_query, (current_opportunity_name,))
        current_opportunity = mycursor.fetchone()

        """
        Fetch the opportunity attributes from the database to load into the form
        """
        awardTypes = []
        eligibleStages = []
        eligibleFields = []
        eligibleNationalities = []

        awardTypeIDs = [int(row[0]) for row in find_joined_attributes(mycursor, current_opportunity[1], 'awardtype')]
        for id in awardTypeIDs:
            mycursor.execute("SELECT name FROM awardtype WHERE id = %s", (id,))
            awardTypes.append(mycursor.fetchone())
        print("These are the awardTypes for staticOpportunity: ", awardTypes)
        eligibleStageIDs = [int(row[0]) for row in find_joined_attributes(mycursor, current_opportunity[1], 'stage')]
        for id in eligibleStageIDs:
            mycursor.execute("SELECT name FROM stage WHERE id = %s", (id,))
            eligibleStages.append(mycursor.fetchone())
        eligibleFieldIDs = [int(row[0]) for row in find_joined_attributes(mycursor, current_opportunity[1], 'field')]
        for id in eligibleFieldIDs:
            mycursor.execute("SELECT name FROM field WHERE id = %s", (id,))
            eligibleFields.append(mycursor.fetchone())
        eligibleNationalityIDs = [int(row[0]) for row in find_joined_attributes(mycursor, current_opportunity[1], 'nationality')]
        for id in eligibleNationalityIDs:
            mycursor.execute("SELECT name FROM nationality WHERE id = %s", (id,))
            eligibleNationalities.append(mycursor.fetchone())


        action = request.values.get('action')
        """
        If the user wants to edit an opportunity that already has data associated with it, they will open the data entry form,
        already populated with the information related to that opportunity.
        """
        if action == 'edit-opportunity-details':
            mycursor.execute("SELECT * FROM organization")
            organizations = mycursor.fetchall()
            current_organization = None
            if current_opportunity and current_opportunity[4]:
                mycursor.execute("SELECT * FROM organization WHERE id=%s", (current_opportunity[4],))
                current_organization = mycursor.fetchone()
            return render_template('admin/_opportunityDataEntry.html', organizations=organizations, opportunity_name=current_opportunity_name, opportunity=current_opportunity, current_organization=current_organization)

        """
        If the opportunity name entered in the form does not have data associated with it, the user will see a data entry form. 
        Here, they will enter basic information about the opportunity. Specifically, the organization that offers it, 
        a brief description of it, and the URL to the actual opportunity.
        """

        """
        Add an operation to update the opportunity details in the database
        """
        if request.method == 'POST':
            mycursor.execute("SELECT * FROM organization")
            organizations = mycursor.fetchall()
            organization = request.values.get('organization_name')
            mycursor.execute("SELECT * FROM organization WHERE name = %s", (organization,))
            existing_organization = mycursor.fetchone()
            if existing_organization == None:
                mycursor.execute("INSERT INTO organization(name) VALUES (%s)", (organization,)) # add the new organization into the organization table if it's not already there
                conn.commit()
            description = request.form.get('opportunity_description')
            website = sanitize_url(request.form.get('website_url'))
            mycursor.execute("SELECT * FROM organization WHERE name = %s", (organization,))
            current_organization = mycursor.fetchone()
            if current_opportunity == None:
                mycursor.execute("INSERT INTO opportunity(name, website, description, organization_id) VALUES (%s, %s, %s, %s)", (current_opportunity_name, website, description, current_organization[1]))
                conn.commit()
            else:    
                mycursor.execute("UPDATE opportunity SET description = %s, website = %s, organization_id = %s WHERE id = %s", (description, website, current_organization[1], current_opportunity[1]))    # update the organization, description, and website for the new opportunity
                conn.commit()

            mycursor.execute(opportunity_query, (current_opportunity_name,))
            current_opportunity = mycursor.fetchone()
            
            """
            Close the cursor and render the template
            """
            mycursor.close()
            conn.close()
            return render_template('admin/_staticOpportunity.html', 
                                   opportunity=current_opportunity, 
                                   organization=current_organization,
                                   awardTypes=awardTypes,
                                   eligibleStages=eligibleStages,
                                   eligibleFields=eligibleFields,
                                   eligibleNationalities=eligibleNationalities)
                
        if current_opportunity is None:
            mycursor.execute("SELECT * FROM organization")
            organizations = mycursor.fetchall()
            mycursor.close()
            conn.close()
            return render_template('admin/_opportunityDataEntry.html', organizations=organizations, opportunity_name=current_opportunity_name) 
        else:
            mycursor.execute("SELECT * from organization WHERE id = %s", (current_opportunity[4],))
            current_organization = mycursor.fetchone()
            mycursor.close()
            conn.close()
            return render_template('admin/_staticOpportunity.html', 
                                   opportunity=current_opportunity, 
                                   organization=current_organization,
                                   awardTypes=awardTypes,
                                   eligibleStages=eligibleStages,
                                   eligibleFields=eligibleFields,
                                   eligibleNationalities=eligibleNationalities)

def add_relationship(cursor, table1, table2, id1, id2):
    """
    Adds a relationship between two entities in a join table.
    
    Parameters:
    - cursor: The database cursor to execute the query.
    - table1: The name of the first table (e.g., 'Opportunity').
    - table2: The name of the second table (e.g., 'Degree').
    - id1: The ID of the entity from the first table.
    - id2: The ID of the entity from the second table.
    
    This function assumes that there is a join table named '{table1}{table2}' with columns '{table1.lower()}_id' and '{table2.lower()}_id'.
    """
    join_table = f"{table1}{table2}"
    column1 = f"{table1.lower()}_id"
    column2 = f"{table2.lower()}_id"
    
    query = f"INSERT INTO {join_table} ({column1}, {column2}) VALUES (%s, %s)"
    cursor.execute(query, (id1, id2))

def init_opportunity_attributes_route(app):
    @app.route('/opportunity-attributes', methods=['GET','POST'])
    def opportunity_attributes():
        print(f"DEBUG: PATH={request.path}, METHOD={request.method}, VALUES={request.values}")
        joinedOpportunity = request.values.get('opportunity_id')
        
        conn = get_db_connection()
        mycursor = conn.cursor(buffered=True)
        

        if request.method == 'POST':
            mycursor.execute("DELETE FROM awardtypeopportunity WHERE opportunity_id = %s", (joinedOpportunity,))
            mycursor.execute("DELETE FROM stageopportunity WHERE opportunity_id = %s", (joinedOpportunity,))
            mycursor.execute("DELETE FROM fieldopportunity WHERE opportunity_id = %s", (joinedOpportunity,))
            mycursor.execute("DELETE FROM nationalityopportunity WHERE opportunity_id = %s", (joinedOpportunity,))
            conn.commit()

            joinedAwardTypes = request.form.getlist('awardType')
            joinedStages = request.form.getlist('stage')
            joinedFields = request.form.getlist('field')
            joinedNationalities = request.form.getlist('nationality')            
            
            # print("These are the selected award types: ", joinedAwardTypes)
            # print("These are the selected stages: ", joinedStages)
            # print("These are the selected fields: ", joinedFields)
            # print("These are the selected nationalities: ", joinedNationalities)
            mycursor.execute("SELECT name FROM opportunity WHERE id = %s", (joinedOpportunity,))
            # print("This is the joinedOpportunity: ", mycursor.fetchone())
            awardTypes = []
            eligibleStages = []
            eligibleFields = []
            eligibleNationalities = []

            for aw in joinedAwardTypes:
                add_relationship(mycursor,'awardtype','opportunity', int(aw), int(joinedOpportunity))
                conn.commit()
                mycursor.execute("SELECT name FROM awardtype WHERE id = %s", (aw,))
                awardTypes.append(mycursor.fetchone())
            for s in joinedStages:
                add_relationship(mycursor,'stage','opportunity', int(s), int(joinedOpportunity))
                conn.commit()
                mycursor.execute("SELECT name FROM stage WHERE id = %s", (s,))
                eligibleStages.append(mycursor.fetchone())
            for f in joinedFields:
                add_relationship(mycursor,'field','opportunity', int(f), int(joinedOpportunity))
                conn.commit()
                mycursor.execute("SELECT name FROM field WHERE id = %s", (f,))
                eligibleFields.append(mycursor.fetchone())
            for n in joinedNationalities:
                add_relationship(mycursor, 'nationality', 'opportunity', int(n), int(joinedOpportunity))
                conn.commit()
                mycursor.execute("SELECT name FROM nationality WHERE id = %s", (n,))
                eligibleNationalities.append(mycursor.fetchone())
            mycursor.execute("SELECT * FROM opportunity WHERE id = %s", (joinedOpportunity,))
            current_opportunity = mycursor.fetchone()
            mycursor.execute("SELECT * FROM organization WHERE id = %s", (current_opportunity[4],))
            current_organization = mycursor.fetchone()

            mycursor.close()
            conn.close()

            content = render_template('admin/_staticOpportunity.html', 
                                   opportunity=current_opportunity, 
                                   organization=current_organization,
                                   awardTypes=awardTypes,
                                   eligibleStages=eligibleStages,
                                   eligibleFields=eligibleFields,
                                   eligibleNationalities=eligibleNationalities)
            
            # Create a response that includes the content AND a header to clear the form
            response = make_response(content)
            response.headers['HX-Trigger-After-Swap'] = 'clear-attributes-form'
            return response
            
        mycursor.execute("SELECT * FROM awardtype")
        allAwardTypes = mycursor.fetchall()
        mycursor.execute("SELECT * FROM stage")
        allStages = mycursor.fetchall()
        mycursor.execute("SELECT * FROM field")
        allFields = mycursor.fetchall()
        mycursor.execute("SELECT * FROM nationality")
        allNationalities = mycursor.fetchall()

        joinedAwardTypes = [int(row[0]) for row in find_joined_attributes(mycursor, joinedOpportunity, 'awardtype')]
        # print("The joinedAwardTypes are ", joinedAwardTypes)
        joinedStages = [int(row[0]) for row in find_joined_attributes(mycursor, joinedOpportunity, 'stage')]
        # print("The joinedStages are ", joinedStages)
        joinedFields = [int(row[0]) for row in find_joined_attributes(mycursor, joinedOpportunity, 'field')]
        # print("The joinedFields are ", joinedFields)
        joinedNationalities = [int(row[0]) for row in find_joined_attributes(mycursor, joinedOpportunity, 'nationality')]
        # print("The joinedNationalities are ", joinedNationalities)

        mycursor.close()
        conn.close()

        return render_template('admin/_opportunityAssignAttributes.html', 
                               opportunity_id=joinedOpportunity, 
                               allAwardTypes=allAwardTypes, 
                               allStages=allStages, 
                               allFields=allFields, 
                               allNationalities=allNationalities,
                               joinedAwardTypes=joinedAwardTypes,
                               joinedStages=joinedStages,
                               joinedFields=joinedFields,
                               joinedNationalities=joinedNationalities)