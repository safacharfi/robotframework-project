from flask import Flask, jsonify, render_template, request, redirect, url_for, flash, session

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# User data
users = {
    'testuser': {
        'username': 'safacharfi',
        'password': 'password',
        'first_name': 'Safa',
        'last_name': 'Charfi',
        'phone': '53998571',
        'role': 'Admin'
    },
    'safacharfi1': {
        'username': 'safacharfi1',
        'password': 'password',
        'first_name': 'Safa',
        'last_name': 'Charfi',
        'phone': '53998571',
        'role': 'Admin'
    }
}

# Global employee list
employees = [
    {'name': 'John Doe', 'role': 'Manager', 'phone': '123456789'},
    {'name': 'Jane Smith', 'role': 'Developer', 'phone': '987654321'},
]

notes = {}

@app.route('/')
def home():
    return render_template('login.html')

@app.route('/settings')
def settings():
    return render_template('settings.html')

@app.route('/get_financial_data')
def get_financial_data():
    # Example financial data
    financial_data = {
        'total_revenue': 100000,
        'total_expenses': 80000,
        'net_profit': 20000,
        'quarterly_revenue': [25000, 30000, 22000, 23000],
        'quarterly_expenses': [20000, 18000, 21000, 21000],
        'quarterly_net_profit': [5000, 12000, 1000, 2000]
    }
    return jsonify(financial_data)

@app.route('/add_employee', methods=['GET', 'POST'])
def add_employee():
    if 'username' not in session or users[session['username']]['role'] != 'Admin':
        return redirect(url_for('home'))

    if request.method == 'POST':
        employee_name = request.form.get('name', '')
        employee_role = request.form.get('role', '')
        employee_phone = request.form.get('phone', '')

        if not employee_name or not employee_role or not employee_phone:
            flash('Please fill out all the required fields.', 'danger')
            return render_template('add_employee.html')

        new_employee = {
            'name': employee_name,
            'role': employee_role,
            'phone': employee_phone
        }
        employees.append(new_employee)
        flash('Employee added successfully!', 'success')
        return redirect(url_for('employee_list'))

    return render_template('add_employee.html')

@app.route('/employee_list')
def employee_list():
    if 'username' not in session:
        return redirect(url_for('home'))

    role_counts = {}
    for employee in employees:
        role = employee['role']
        role_counts[role] = role_counts.get(role, 0) + 1

    return render_template('employee_list.html', employees=employees, role_counts=role_counts)

@app.route('/filter_employees', methods=['POST'])
def filter_employees():
    if 'username' not in session:
        return redirect(url_for('home'))

    role_filter = request.form['role_filter']
    filtered_employees = [emp for emp in employees if emp['role'] == role_filter or role_filter == ""]
    
    return render_template('employee_list.html', employees=filtered_employees)

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    user = users.get(username)
    if user and user['password'] == password:
        session['username'] = username
        return redirect(url_for('dashboard'))
    else:
        flash('Invalid credentials')
        return redirect(url_for('home'))

@app.route('/profile', methods=['GET', 'POST'])
def profile():
    if 'username' not in session:
        return redirect(url_for('home'))
    
    user = users[session['username']]
    
    if request.method == 'POST':
        new_username = request.form['username']
        new_first_name = request.form['first_name']
        new_last_name = request.form['last_name']
        new_phone = request.form['phone']

        if new_username and new_username != session['username']:
            if new_username not in users:
                users[new_username] = users.pop(session['username'])
                session['username'] = new_username
                flash('Username updated successfully!')
            else:
                flash('Username already taken!')

        users[session['username']]['first_name'] = new_first_name
        users[session['username']]['last_name'] = new_last_name
        users[session['username']]['phone'] = new_phone
        
        return redirect(url_for('profile'))

    return render_template('profile.html', user=user)

@app.route('/dashboard')
def dashboard():
    if 'username' not in session:
        return redirect(url_for('home'))
    user_notes = notes.get(session['username'], [])
    return render_template('dashboard.html', username=session['username'], notes=user_notes)
notes = {}

@app.route('/notes')
def notes_page():
    if 'username' not in session:
        return redirect(url_for('home'))
    
    # Get the list of notes for the logged-in user
    user_notes = notes.get(session['username'], [])
    
    # Get the length of the notes list
    notes_length = len(user_notes)
    
    return render_template('notes.html', notes=user_notes, notes_length=notes_length)


@app.route('/add_note', methods=['POST'])
def add_note():
    if 'username' not in session:
        return redirect(url_for('home'))
    
    note_content = request.form['note']
    
    if not note_content.strip():  # Check if the note is empty or just whitespace
        flash('Note cannot be empty!', 'danger')  # Send a flash message
        return redirect(url_for('notes_page'))  # Redirect to the notes page
    
    # If the note is not empty, add it to the notes
    if session['username'] not in notes:
        notes[session['username']] = []
    notes[session['username']].append(note_content)
    flash('Note added successfully!', 'success')
    return redirect(url_for('notes_page'))  # Redirect to notes page

@app.route('/length_notes')
def length_notes():
    if 'username' not in session:
        return redirect(url_for('home'))
    
    # Get the list of notes for the logged-in user
    user_notes = notes.get(session['username'], [])
    
    # Return the length of the notes list
    return str(len(user_notes))


@app.route('/delete_note/<int:note_index>', methods=['POST'])
def delete_note(note_index):
    if 'username' not in session:
        return redirect(url_for('home'))
    if session['username'] in notes and note_index < len(notes[session['username']]):
        notes[session['username']].pop(note_index)
        flash('Note deleted successfully!')
    return redirect(url_for('notes_page'))  # Redirect to notes page

@app.route('/edit_note/<int:note_index>', methods=['GET', 'POST'])
def edit_note(note_index):
    if 'username' not in session:
        return redirect(url_for('home'))
    
    if request.method == 'POST':
        new_content = request.form['note']
        if session['username'] in notes and note_index < len(notes[session['username']]):
            notes[session['username']][note_index] = new_content
            flash('Note updated successfully!')
        return redirect(url_for('notes_page'))  # Redirect to notes page
    
    note_to_edit = notes[session['username']][note_index] if session['username'] in notes and note_index < len(notes[session['username']]) else ""
    return render_template('edit_note.html', note=note_to_edit, note_index=note_index)

@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for('home'))

if __name__ == '__main__':
    app.run(debug=True)