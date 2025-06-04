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

    user_id = g.user.user_id

    success_count = 0
    errors = []

    rc_to_msg = {
        1: "Session not found.",
        2: "Session full.",
        3: "Duplicate booking.",
        4: "Unexpected error occurred.",
        5: "User not found.",
        6: "Not enough money in your balance.",
        7: "Unknown session type."
    }

    for session_id in session['cart']:
        rc = booking.create_booking(user_id, session_id)
        if rc == 0:
            success_count += 1
        else:
            msg = rc_to_msg.get(rc, "Unknown error.")
            errors.append(f"Session {session_id}: {msg}")

    session['cart'] = []
    session.modified = True

    if success_count and not errors:
        full_message = f"All {success_count} booking(s) confirmed successfully!"
    elif success_count and errors:
        errs = " ".join(errors)
        full_message = f"{success_count} booking(s) succeeded. Failed: {errs}"
    else:
        full_message = "No bookings succeeded. " + " ".join(errors)

    return render_template(
        "session/booking_cart_items.html",
        sessions=[],
        message=full_message
    )

@bp.route("/filter", methods=["POST"])
def filter_route():

    sType = request.form.get("type") or None
    instructor_name = request.form.get("instructor") or None

    try:
        duration_min = int(request.form["min_duration"]) if request.form.get("min_duration") else None
    except ValueError:
        return "Invalid minimum duration", 400

    try:
        duration_max = int(request.form["max_duration"]) if request.form.get("max_duration") else None
    except ValueError:
        return "Invalid maximum duration", 400


    search_date = request.form.get("date") or None

    try:
        filtered = sessionn.filter_sessions(
            sType=sType,
            instructor_name=instructor_name,
            duration_min=duration_min,
            duration_max=duration_max,
            search_date=search_date
        )
    except Exception as e:
        return f"Filter error: {str(e)}", 500


    return render_template("session/session_list.html", sessions=filtered)