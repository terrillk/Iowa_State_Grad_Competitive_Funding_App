import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv() # load environment variables from .env file

db = mysql.connector.connect(
    host=os.getenv("DB_HOST"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    database=os.getenv("DB_NAME")
)

mycursor = db.cursor() # create a cursor object to run queries in the database
def create_table_and_join_table(cursor, table):
    cursor.execute(f"CREATE TABLE IF NOT EXISTS {table} (name VARCHAR(255) NOT NULL, id INT AUTO_INCREMENT PRIMARY KEY)") # create a table with columns name and id
    cursor.execute(f"CREATE TABLE IF NOT EXISTS {table}Opportunity ({table.lower()}_id INT NOT NULL, CONSTRAINT fk_{table.lower()}_opportunity FOREIGN KEY ({table.lower()}_id) REFERENCES {table}(id), opportunity_id INT NOT NULL, CONSTRAINT fk_opportunity_{table.lower()} FOREIGN KEY (opportunity_id) REFERENCES Opportunity(id))") # create a join table with foreign key constraints:

# mycursor.execute("CREATE DATABASE IF NOT EXISTS competitivefunding") # create a database named competitivefunding if it doesn't already exist

mycursor.execute("CREATE TABLE IF NOT EXISTS Department (name VARCHAR(255) NOT NULL, id INT AUTO_INCREMENT PRIMARY KEY)") # create a table named Department with columns name and id
# mycursor.execute("DROP TABLE IF EXISTS DepartmentProgram") # drop the DepartmentProgram table if it already exists to avoid errors when running this file multiple times
# mycursor.execute("DROP TABLE IF EXISTS Program")
# mycursor.execute("DROP TABLE IF EXISTS DegreeProgram")
mycursor.execute("CREATE TABLE IF NOT EXISTS Program (name VARCHAR(255) NOT NULL, interdepartmental BOOLEAN DEFAULT FALSE, id INT AUTO_INCREMENT PRIMARY KEY)") # create a table named Program with columns name and id
mycursor.execute("CREATE TABLE IF NOT EXISTS DEGREE (name VARCHAR(255) NOT NULL, abbreviation VARCHAR(10) NOT NULL, id INT AUTO_INCREMENT PRIMARY KEY)") # create a table named DEGREE with columns name, abbreviation, and id
# mycursor.execute("CREATE TABLE IF NOT EXISTS DepartmentProgram (department_id INT NOT NULL, CONSTRAINT fk_department_prog FOREIGN KEY (department_id) REFERENCES Department(id), program_id INT NOT NULL, CONSTRAINT fk_program_dept FOREIGN KEY (program_id) REFERENCES Program(id))") # create a table named DepartmentProgram with foreign key constraints
# mycursor.execute("CREATE TABLE IF NOT EXISTS DegreeProgram (degree_id INT NOT NULL, CONSTRAINT fk_degree_prog FOREIGN KEY (degree_id) REFERENCES DEGREE(id), program_id INT NOT NULL, CONSTRAINT fk_program_deg FOREIGN KEY (program_id) REFERENCES Program(id)") # create a table named DegreeProgram with foreign key constraints
mycursor.execute("CREATE TABLE IF NOT EXISTS Student (name VARCHAR(255) NOT NULL, id INT AUTO_INCREMENT PRIMARY KEY)") # create a table named Student with columns name and id

mycursor.execute("DROP TABLE IF EXISTS StageOpportunity")
mycursor.execute("DROP TABLE IF EXISTS FieldOpportunity")
mycursor.execute("DROP TABLE IF EXISTS NationalityOpportunity")
mycursor.execute("DROP TABLE IF EXISTS AwardTypeOpportunity")
mycursor.execute("DROP TABLE IF EXISTS CycleOpportunity")
mycursor.execute("DROP TABLE IF EXISTS Opportunity")
mycursor.execute("CREATE TABLE IF NOT EXISTS Opportunity (name VARCHAR(255) NOT NULL, id INT AUTO_INCREMENT PRIMARY KEY, website VARCHAR(2048), description MEDIUMTEXT, organization_id INT, CONSTRAINT fk_opportunity_org FOREIGN KEY (organization_id) REFERENCES Organization(id))") # create a table named Opportunity with columns name, description,  and id, with a foreign key constraint on program_id referencing the Organization table
create_table_and_join_table(mycursor, "Stage")
create_table_and_join_table(mycursor, "Field")
create_table_and_join_table(mycursor, "Nationality")
create_table_and_join_table(mycursor, "AwardType")
# create_table_and_join_table(mycursor, "Organization")
create_table_and_join_table(mycursor, "Cycle")

# mycursor.execute("ALTER TABLE Opportunity ADD COLUMN description TEXT") # add a column named description to the Opportunity table
# mycursor.execute("DROP TABLE IF EXISTS OrganizationOpportunity") # drop the OrganizationOpportunity table if it already exists to avoid errors when running this file multiple times
# mycursor.execute("ALTER TABLE Opportunity ADD COLUMN organization_id INT, ADD CONSTRAINT fk_opportunity_org, ADD FOREIGN KEY (organization_id) REFERENCES Organization(id)") # add a column named organization_id to the Opportunity table

# mycursor.execute("ALTER TABLE DepartmentProgram ADD UNIQUE (department_id, program_id)") # add a unique constraint to the DepartmentProgram table to prevent duplicate entries
# mycursor.execute("ALTER TABLE DegreeProgram ADD UNIQUE (degree_id, program_id)") # add a unique constraint to the DegreeProgram table to prevent duplicate entries

db.close() # close the database connection