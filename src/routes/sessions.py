from flask import Blueprint, abort, render_template, request, session, g
from persistence import booking, sessionn

bp = Blueprint('sessions', __name__, url_prefix='/sessions')

@bp.route('/')
def home():
  sessions = sessionn.list_all()
  return render_template('session/session.html', sessions=sessions)

@bp.route("/<int:session_id>/details")
def session_details(session_id):
    session = sessionn.read(session_id)
    if not session:
      abort(404, description="Booking not found")
    return render_template("session/session_details.html", session=session)

# Route for confirming bookings
@bp.route("/create", methods=["POST"])
def create_booking_route():
  try:
     user_id = int(request.form['user_id'])
     session_id = int(request.form['session_id'])
  except (KeyError, ValueError):
     abort(400, description="Missing or invalid user_id/session_id")

  success = booking.create_booking(user_id, session_id)
  if not success:
     # The SP failed
     abort(400, description="Unable to create booking")

  return "success", 200


# add to cart
@bp.route('/add/<int:session_id>', methods=['POST'])
def add_to_cart(session_id):
    if 'cart' not in session:
        session['cart'] = []

    if session_id not in session['cart']:
        session['cart'].append(session_id)
        session.modified = True  # update the session

    cart_sessions = [sessionn.read(sid) for sid in session['cart']]
    return render_template('session/booking_cart_items.html', sessions=cart_sessions)


# remvove from cart
@bp.route("/remove/<int:session_id>", methods=["POST"])
def remove_from_cart(session_id):
    if 'cart' not in session:
        return "", 400

    if session_id in session['cart']:
        session['cart'].remove(session_id)
        session.modified = True

    cart_sessions = [sessionn.read(sid) for sid in session['cart']]
    return render_template('session/booking_cart_items.html', sessions=cart_sessions)


@bp.route("/confirm", methods=["POST"])
def create_multiple_bookings():
    if 'cart' not in session or not session['cart']:
        return "No sessions to book.", 400

    user_id = g.user.user_id  # user currently logged in
    success_count = 0

    for session_id in session['cart']:
        if booking.create_booking(user_id, session_id):
            success_count += 1

    session['cart'] = []
    session.modified = True

    return render_template("session/booking_cart_items.html", sessions=[],
                           message=f"{success_count} booking(s) confirmed.")
