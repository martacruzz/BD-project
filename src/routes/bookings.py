from flask import Blueprint, jsonify, render_template, g
from persistence.user import get_user_bookings
from persistence import user

bp = Blueprint('bookings', __name__, url_prefix='/bookings')

@bp.route("/")
def home():
    if not g.user:
      return "Unauthorized", 401 

    bookings = user.get_user_bookings(g.user.user_id)
    return render_template("user/user.html", bookings=bookings, user=g.user)