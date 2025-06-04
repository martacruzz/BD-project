from flask import Blueprint, abort, render_template, g, redirect, url_for, request
from persistence.booking import get_booking_details, delete_booking
from persistence import user, sessionn, session

bp = Blueprint('bookings', __name__, url_prefix='/bookings')

@bp.route("/<int:booking_id>/details")
def booking_details(booking_id):
    booking = get_booking_details(booking_id)
    if not booking:
      abort(404, description="Booking not found")
    return render_template("booking/booking_details.html", booking=booking)


@bp.route("/delete/<int:booking_id>", methods=["DELETE"])
def delete_booking_route(booking_id):
    success = delete_booking(booking_id)
    bookings = user.get_user_bookings(g.user.user_id)
    if not success:
      abort(404, description="Booking not found or could not be deleted")
    return render_template("booking/booking_list.html", bookings=bookings)

# route for searching bookings
@bp.route('/search')
def search_bookings():
    query = request.args.get('query', '').strip().lower()
    user_id = g.user.user_id

    bookings = user.get_user_bookings(user_id)

    if query:
      bookings = [ b for b in bookings if query in b.instructor_name.lower() or query in b.sType.lower()]

    return render_template("booking/booking_list.html", bookings=bookings)
