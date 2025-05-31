from flask import Blueprint, render_template, g
from persistence.payment import list_payments_by_month, list_user_payments, total_paid_by_user

bp = Blueprint('balance', __name__, url_prefix='/balance')

@bp.route('/')
def home():
  return render_template(
    "balance/balance.html",
    payments=list_user_payments(g.user.user_id),
    total_paid=total_paid_by_user(g.user.user_id),
    monthly_summary=list_payments_by_month(g.user.user_id),
)
