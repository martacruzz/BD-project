from typing import NamedTuple
from datetime import datetime
from persistence.session import create_connection


class PaymentDescriptor(NamedTuple):
  payment_id: int
  cost: float
  date: str
  booking_id: int
  session_type: str
  session_date: str

# TODO implement with trigger
def add_payment(user_id: int, cost: float, booking_id: int) -> int:
    """Adds a payment entry and returns the new payment_id."""
    raise NotImplementedError()

def list_user_payments(user_id: int) -> list[PaymentDescriptor]:
    """Gives us all payments made by a given user by id"""
    with create_connection() as conn:
      cursor = conn.cursor()
      cursor.execute("""
          SELECT p.payment_id, p.cost, p.registration_date,
                  p.booking_id,
                  s.sType AS session_type,
                  s.date_time AS session_date
          FROM municipal.payment p
          LEFT JOIN municipal.booking b ON p.booking_id = b.booking_id
          LEFT JOIN municipal.sessionn s ON b.session_id = s.session_id
          WHERE p.user_id = ?
          ORDER BY p.registration_date DESC;
      """, user_id)

      rows = cursor.fetchall()
      return [PaymentDescriptor(*row) for row in rows]


def total_paid_by_user(user_id: int) -> float:
    """Gives us the total amount spent by the user with all the payments they made"""
    with create_connection() as conn:
      cursor = conn.cursor()
      cursor.execute("""
          SELECT SUM(cost)
          FROM municipal.payment
          WHERE user_id = ?;
      """, user_id)
      total = cursor.fetchone()[0]
      return total if total else 0.0


def list_payments_by_month(user_id: int) -> dict[str, float]:
    """Returns a dictionary {YYYY-MM: total_paid} for a given user."""
    with create_connection() as conn:
      cursor = conn.cursor()
      cursor.execute("""
        SELECT FORMAT(registration_date, 'yyyy-MM') AS month, SUM(cost) AS total
        FROM municipal.payment
        WHERE user_id = ?
        GROUP BY FORMAT(registration_date, 'yyyy-MM')
        ORDER BY month DESC;
      """, user_id)

      return {row[0]: row[1] for row in cursor.fetchall()}
