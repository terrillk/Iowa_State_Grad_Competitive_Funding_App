from flask import app, render_template, request, redirect
from dbQueries import save_department_to_competitive_funding_database, get_all_departments_from_competitive_funding_database


def init_new_department_route(app):
    @app.route('/new-department')
    def new_department():
        return render_template('admin/departmentInputForm.html')

    @app.route('/submit-new-department', methods=['POST'])
    def handle_form_submission():
        #a Grab the data coming from the HTML form 'name' attributes
        department = request.form.get('name')

        #b Insert the data into the MySQL table
        save_department_to_competitive_funding_database(department)
        return redirect('/department-list')

def init_department_list_route(app):
    @app.route('/department-list')
    def view_records():
        all_departments = get_all_departments_from_competitive_funding_database()

        return render_template('admin/departmentList.html', departments=all_departments)
