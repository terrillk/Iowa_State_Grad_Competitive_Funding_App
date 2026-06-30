from flask import Flask, render_template, request, redirect
# import mysql.connector
# from dbQueries import save_department_to_competitive_funding_database, get_all_departments_from_competitive_funding_database, list_interdepartmental_programs, list_departments_for_program, add_department_program_relationship, get_program_name_by_id
from routes.departments import init_new_department_route, init_new_department_route, init_department_list_route
from routes.opportunities import init_manage_opportunities_route, init_opportunity_details_route, init_opportunity_attributes_route

# 1a. initialise the Flask application
app = Flask(__name__)

#2 Define a route (URL) and what happens
@app.route('/') # this means that when the user goes to the root URL of the website (e.g., http://localhost:5000/), the following function will be executed
def home():
    return render_template('customer/home.html')

init_new_department_route(app)
init_department_list_route(app)
init_manage_opportunities_route(app)
init_opportunity_details_route(app)
init_opportunity_attributes_route(app)








#3 Start the server if this file is run directly
if __name__ == '__main__': # this means that if we run this file, the Flask server will start. If we import this file into another file, the Flask server will not start.
    app.run(debug=True)
    