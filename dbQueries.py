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


def save_department_to_competitive_funding_database(department):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO Department (name) VALUES (%s)", (department,))
    
    conn.commit() #save changes to MySQL
    cursor.close()
    conn.close()

def get_all_departments_from_competitive_funding_database():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT id, name FROM department")

    all_records = cursor.fetchall()
    all_records.sort(key=lambda x: x[1]) # sort the records alphabetically

    cursor.close()
    conn.close()
    return all_records
    
def list_interdepartmental_programs():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT id, name FROM program WHERE interdepartmental = TRUE")

    all_records = cursor.fetchall()
    all_records.sort(key=lambda x: x[1]) # sort the records alphabetically

    cursor.close()
    conn.close()
    return all_records

def get_program_name_by_id(program_id):
    conn = get_db_connection()
    cursor = conn.cursor()

    query = "SELECT name FROM program WHERE id = %s"
    cursor.execute(query, (program_id,))

    result = cursor.fetchone()
    program_name = result[0] if result else None

    cursor.close()
    conn.close()
    return program_name