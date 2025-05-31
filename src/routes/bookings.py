from flask import Blueprint, abort, render_template, g
from persistence.booking import get_booking_details
from persistence import user

bp = Blueprint('bookings', __name__, url_prefix='/bookings')

@bp.route("/")
def home():
    if not g.user:
      return "Unauthorized", 401 

    bookings = user.get_user_bookings(g.user.user_id)
    return render_template("user/user.html", bookings=bookings, user=g.user)

@bp.route("/<int:booking_id>/details")
def booking_details(booking_id):
    booking = get_booking_details(booking_id)
    if not booking:
      abort(404, description="Booking not found")
    return render_template("booking/booking_details.html", booking=booking)