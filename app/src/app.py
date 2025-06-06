import datetime
import hashlib
from flask import Flask, render_template, request, make_response, g
import secrets

from routes.bookings import bp as bookings_bp
from routes.sessions import bp as sessions_bp
from routes.balance import bp as balance_bp

from persistence import user

app = Flask(__name__)

# Generate a random 32‐byte key and assign it
app.secret_key = secrets.token_hex(32)

app.register_blueprint(bookings_bp)
app.register_blueprint(sessions_bp)
app.register_blueprint(balance_bp)

# dummy user login
@app.before_request
def load_dummy_user():
    dummy_user_id = 1 
    g.user = user.read(dummy_user_id)


@app.route("/")
def home():
    if not g.user:
      return "Unauthorized", 401 

    bookings = user.get_user_bookings(g.user.user_id)
    return render_template("user/user.html", bookings=bookings, user=g.user)


if __name__ == "__main__":
    app.run(debug=True)
