from flask import Blueprint, abort, render_template
from persistence.sessionn import list_all, read

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