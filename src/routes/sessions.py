from flask import Blueprint, render_template, g
from persistence.sessionn import list_all

bp = Blueprint('sessions', __name__, url_prefix='/sessions')

@bp.route('/')
def home():
  sessions = list_all()
  return render_template('session/session.html', sessions=sessions)