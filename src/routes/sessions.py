from flask import Blueprint, abort, render_template, request, session
from persistence.sessionn import list_all, read
from persistence.booking import create_booking

bp = Blueprint('sessions', __name__, url_prefix='/sessions')

@bp.route('/')
def home():
  sessions = list_all()
  return render_template('session/session.html', sessions=sessions)

@bp.route("/<int:session_id>/details")
def session_details(session_id):
    session = read(session_id)
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

  success = create_booking(user_id, session_id)
  if not success:
     # The SP failed
     abort(400, description="Unable to create booking")

  return "success", 200


# Route to add booking to cart
@bp.route("/add-to-cart", methods=["POST"])
def add_to_cart():
  session_id = request.form.get('session_id')
  if not session_id:
    return "", 400
   
  # Initialize cart in session if not exists
  if 'booking_cart' not in session:
    session['booking_cart'] = []

  # Add session to cart (prevents duplicates)
  if session_id not in session['booking_cart']:
    session['booking_cart'].append(session_id)
    session.modified = True
    

  return "", 200
  

# Route to render cart contents
@bp.route("/booking/cart")
def booking_cart():
    cart = session.get('booking_cart', [])
    sessions_in_cart = []

    if cart:
        # Fetch session details from database
        all_sessions = list_all()
        for sess in all_sessions:
            if str(sess.session_id) in cart:  # Convert to string for comparison
                sessions_in_cart.append({
                    'id': sess.session_id,
                    'type': sess.sType,
                    'date': sess.date_time.strftime('%Y-%m-%d %H:%M'),
                    'duration': sess.duration  # Add duration since it's in the template
                })
    return render_template('partials/booking_cart.html', sessions=sessions_in_cart)  

# Remove from cart
@bp.route("/sessions/remove-from-cart", methods=["POST"])
def remove_from_cart():
    session_id = request.form.get('session_id')
    if not session_id or 'booking_cart' not in session:
        return "", 400
    
    # Convert to string for consistent comparison
    session_id = str(session_id)
    
    if session_id in session['booking_cart']:
        session['booking_cart'].remove(session_id)
        session.modified = True
    
    return booking_cart()  # Return updated cart HTML

# Endpoint for multiple booking creation
@bp.route("/bookings/create-multiple", methods=["POST"])
def create_multiple_bookings():
  if 'user_id' not in session or 'booking_cart' not in session:
    return "Authentication required", 401
  
  user_id = session['user_id']
  cart = session.get('booking_cart', [])
  results = []

  for session_id in cart:
    success = create_booking(user_id, int(session_id))
    results.append({
      'session_id': session_id,
      'success': success
    })

  # Clear cart after processing
  session['booking_cart'] = []
  session.modified = True

  # Return results summary
  success_count = sum(1 for r in results if r['success'])
  return render_template('partials/booking_result.html',
                         results=results,
                         success_count = success_count,
                         total_count=len(results))

