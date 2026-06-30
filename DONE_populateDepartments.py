import mysql.connector
import csv
from dotenv import load_dotenv

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


def populate_departments_from_csv():
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        with open('departments.csv', 'r', encoding='utf-8') as file:
            csv_reader = csv.reader(file)
            
            # 1. Uncomment this if your CSV has a header row!
            # next(csv_reader, None) 

            for row in csv_reader:
                # 2. Skip completely empty rows
                if not row or not row[0].strip():
                    continue
                
                # 3. Clean up trailing spaces or hidden characters (\n, \r)
                department_name = row[0].strip()
                
                insert_query = "INSERT INTO Department (name) VALUES (%s)"
                
                # 4. Using a list instead of a single-item tuple for stability
                cursor.execute(insert_query, [department_name])
                
        # Commit inside the try block so it only saves if reading succeeded
        conn.commit()
        print("Departments populated successfully!")

    except Exception as e:
        print(f"An error occurred: {e}")
        conn.rollback() # Rollback changes if something went wrong
        
    finally:
        cursor.close()
        conn.close()

populate_departments_from_csv()