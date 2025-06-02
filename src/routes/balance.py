from flask import Blueprint, render_template, g, request, redirect, url_for
from persistence.payment import list_payments_by_month, list_user_payments, total_paid_by_user, add_payment

bp = Blueprint('balance', __name__, url_prefix='/balance')

@bp.route('/')
def home():
  return render_template(
    "balance/balance.html",
    payments=list_user_payments(g.user.user_id),
    total_paid=total_paid_by_user(g.user.user_id),
    monthly_summary=list_payments_by_month(g.user.user_id),
    user = g.user
)

@bp.route('/<int:user_id>/add', methods=['POST'])
def add(user_id: int):
  try:
    amount = float(request.form['amount'])
    if amount <= 0:
      raise ValueError("Amount must be positive.")
    add_payment(user_id, amount)
  except (KeyError, ValueError):
    return "Invalid amount", 400

  return redirect(url_for('balance.home'))

