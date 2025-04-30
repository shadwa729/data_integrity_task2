from flask import Flask, render_template, request, redirect, url_for, session, make_response
from flask_mysqldb import MySQL
from flask_bcrypt import Bcrypt
import config
import re
import requests
from datetime import timedelta

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# Session config
app.config['SESSION_COOKIE_HTTPONLY'] = True
app.config['SESSION_COOKIE_SECURE'] = False  # Set to True only on HTTPS
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
app.permanent_session_lifetime = timedelta(minutes=30)

# MySQL config
app.config['MYSQL_HOST'] = config.DB_HOST
app.config['MYSQL_USER'] = config.DB_USER
app.config['MYSQL_PASSWORD'] = config.DB_PASSWORD
app.config['MYSQL_DB'] = config.DB_NAME

mysql = MySQL(app)
bcrypt = Bcrypt(app)

@app.route('/')
def home():
    if 'user_id' in session:
        return render_template('home.html', username=session['username'])
    return redirect(url_for('login'))

@app.route('/test_db')
def test_db():
    try:
        cur = mysql.connection.cursor()
        cur.execute('SELECT 1')
        return 'Database Connected Successfully!'
    except Exception as e:
        return f'Error connecting to database: {str(e)}'

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']

        if not validate_password(password):
            return render_template('signup.html', error="Password does not meet policy requirements.")

        hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')

        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE username = %s OR email = %s", (username, email))
        if cur.fetchone():
            return render_template('signup.html', error="Username or email already exists.")

        cur.execute(
            "INSERT INTO users (username, email, password, auth_method) VALUES (%s, %s, %s, 'manual')",
            (username, email, hashed_password)
        )
        mysql.connection.commit()
        cur.close()
        return render_template('signup.html', success="Account created successfully. Please login.")
    return render_template('signup.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    cur = mysql.connection.cursor()
    if request.method == 'POST':
        username_email = request.form['username_email']
        password = request.form['password']
        remember = request.form.get('remember')

        cur.execute("SELECT * FROM users WHERE username = %s OR email = %s", (username_email, username_email))
        user = cur.fetchone()

        ip_address = request.remote_addr
        user_agent = request.headers.get('User-Agent')
        method = "manual"

        if user and bcrypt.check_password_hash(user[3], password):
            session.permanent = True if remember else False
            session['user_id'] = user[0]
            session['username'] = user[1]

            cur.execute(
                "INSERT INTO login_logs (user_id, ip_address, user_agent, method, success, details) "
                "VALUES (%s, %s, %s, %s, %s, %s)",
                (user[0], ip_address, user_agent, method, True, "Login successful")
            )
            mysql.connection.commit()
            cur.close()
            return redirect(url_for('home'))

        else:
            cur.execute(
                "INSERT INTO login_logs (user_id, ip_address, user_agent, method, success, details) "
                "VALUES (%s, %s, %s, %s, %s, %s)",
                (None, ip_address, user_agent, method, False, "Invalid credentials")
            )
            mysql.connection.commit()
            cur.close()
            return render_template('login.html', error="Invalid credentials.")
    return render_template('login.html')

@app.route('/github/login')
def github_login():
    github_authorize_url = f"https://github.com/login/oauth/authorize?client_id={config.GITHUB_CLIENT_ID}&scope=user:email"
    return redirect(github_authorize_url)

@app.route('/github/callback')
def github_callback():
    code = request.args.get('code')
    token_url = 'https://github.com/login/oauth/access_token'
    token_data = {
        'client_id': config.GITHUB_CLIENT_ID,
        'client_secret': config.GITHUB_CLIENT_SECRET,
        'code': code
    }
    headers = {'Accept': 'application/json'}
    token_response = requests.post(token_url, data=token_data, headers=headers)
    token_json = token_response.json()
    access_token = token_json.get('access_token')

    if not access_token:
        return redirect(url_for('login'))

    user_info_url = 'https://api.github.com/user'
    headers = {'Authorization': f'token {access_token}'}
    user_info_response = requests.get(user_info_url, headers=headers)
    user_info = user_info_response.json()

    github_id = str(user_info.get('id'))
    username = user_info.get('login')
    email = user_info.get('email') or f"{github_id}@github.com"

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM users WHERE github_id = %s", (github_id,))
    existing_user = cur.fetchone()

    if existing_user:
        user_id = existing_user[0]
    else:
        cur.execute(
            "INSERT INTO users (username, email, auth_method, github_id) VALUES (%s, %s, 'github', %s)",
            (username, email, github_id)
        )
        mysql.connection.commit()
        user_id = cur.lastrowid

    session['user_id'] = user_id
    session['username'] = username

    ip_address = request.remote_addr
    user_agent = request.headers.get('User-Agent')
    method = "github"

    cur.execute(
        "INSERT INTO login_logs (user_id, ip_address, user_agent, method, success, details) "
        "VALUES (%s, %s, %s, %s, %s, %s)",
        (user_id, ip_address, user_agent, method, True, "GitHub login successful")
    )
    mysql.connection.commit()
    cur.close()

    return redirect(url_for('home'))

@app.route('/logout')
def logout():
    session.clear()
    resp = make_response(redirect(url_for('login')))
    resp.headers['Cache-Control'] = 'no-store'
    return resp

def validate_password(password):
    if (len(password) >= 8 and
        re.search(r"[A-Z]", password) and
        re.search(r"[a-z]", password) and
        re.search(r"[0-9]", password) and
        re.search(r"[!@#$%^&*(),.?\":{}|<>]", password)):
        return True
    return False

if __name__ == "__main__":
    app.run(debug=True)
