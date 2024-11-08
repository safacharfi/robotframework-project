from flask import Flask, render_template, request, redirect, url_for, flash, session

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# Dummy user data and notes storage
users = {
    'testuser': {
        'password': 'password',
        'first_name': 'John',
        'last_name': 'Doe',
        'phone': '123-456-7890',
        'role': 'Admin'
    }
}
notes = {}

@app.route('/')
def home():
    return render_template('login.html')
@app.route('/settings')
def settings():
    return render_template('settings.html')


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

        # Update other user details
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

@app.route('/add_note', methods=['POST'])
def add_note():
    if 'username' not in session:
        return redirect(url_for('home'))
    note_content = request.form['note']
    if session['username'] not in notes:
        notes[session['username']] = []
    notes[session['username']].append(note_content)
    flash('Note added successfully!')
    return redirect(url_for('dashboard'))

@app.route('/delete_note/<int:note_index>', methods=['POST'])
def delete_note(note_index):
    if 'username' not in session:
        return redirect(url_for('home'))
    if session['username'] in notes and note_index < len(notes[session['username']]):
        notes[session['username']].pop(note_index)
        flash('Note deleted successfully!')
    return redirect(url_for('dashboard'))

@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for('home'))

@app.route('/edit_note/<int:note_index>', methods=['GET', 'POST'])
def edit_note(note_index):
    if 'username' not in session:
        return redirect(url_for('home'))
    if request.method == 'POST':
        new_content = request.form['note']
        if session['username'] in notes and note_index < len(notes[session['username']]):
            notes[session['username']][note_index] = new_content
            flash('Note updated successfully!')
        return redirect(url_for('dashboard'))
    
    
    note_to_edit = notes[session['username']][note_index] if session['username'] in notes and note_index < len(notes[session['username']]) else ""
    return render_template('edit_note.html', note=note_to_edit, note_index=note_index)

if __name__ == '__main__':
    app.run(debug=True)