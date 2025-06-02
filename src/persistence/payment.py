from typing import NamedTuple
from datetime import datetime
from persistence.session import create_connection


class PaymentDescriptor(NamedTuple):
  payment_id: int
  cost: float
  date: str
  # booking_id: int
  # session_type: str
  # session_date: str

# Create a payment (there is a trigger to make sure the balance isn't negative)
def add_payment(user_id: int, cost: float) -> int:
    """Adds a payment entry and returns the new payment_id."""
    with create_connection() as conn:
      cursor = conn.cursor()

      # Prepare output variable
      new_payment_id = cursor.execute("""
        declare @new_payment_id int;
        
        exec municipal.MakePayment
          @user_id = ?,
          @cost = ?,
          @new_payment_id = @new_payment_id output;
          
        select @new_payment_id;
      """, (user_id, cost)).fetchone()[0]

      return new_payment_id



# History of all user payments (with UDF)
def list_user_payments(user_id: int) -> list[PaymentDescriptor]:
    """Gives us all payments made by a given user by id"""

    with create_connection() as conn:
      cursor = conn.cursor()

      cursor.execute("""
        select payment_id, cost, pay_time
        from municipal.payment as p
        where p.user_id = ?
        order by pay_time desc;
      """, user_id)


      rows = cursor.fetchall()
      return [PaymentDescriptor(*row) for row in rows]

# Only adds negative payments (so the amount the user spent) (uses the history UDF)
def total_paid_by_user(user_id: int) -> float:
    """Gives us the total amount spent by the user with all the payments they made"""
    with create_connection() as conn:
      cursor = conn.cursor()
      cursor.execute("""
          SELECT SUM(cost)
          FROM municipal.payment as p
          WHERE p.cost < 0 and p.user_id = ?;
      """, user_id)

      row = cursor.fetchone()
      negative_sum = row[0] if row and row[0] is not None else 0.0

      # Return the absulute value
      return abs(negative_sum)


def list_payments_by_month(user_id: int) -> dict[str, float]:
    """Returns a dictionary {YYYY-MM: total_paid} for a given user."""
    with create_connection() as conn:
      cursor = conn.cursor()
      cursor.execute("""
        SELECT FORMAT(pay_time, 'yyyy-MM') AS month, SUM(cost) AS total
        FROM municipal.payment
        WHERE user_id = ?
        GROUP BY FORMAT(pay_time, 'yyyy-MM')
        ORDER BY month DESC;
      """, user_id)

      return {row[0]: row[1] for row in cursor.fetchall()}
