from typing import NamedTuple
from datetime import datetime
from persistence.session import create_connection


class BookingDetails(NamedTuple):
  booking_id: int
  status: str
  booking_date: str
  user_id: int
  session_id: int
  cost: float
  session_type: str
  session_datetime: str
  pool_name: str
  lane_number: int
  lane_status: str
  instructor_name: str
  max_capacity: int
  booked_count: int

# TODO implement with trigger
def create_booking(user_id: int, session_id: int) -> bool:
  """Creates a booking with all security checks"""
  raise NotImplementedError()

def get_booking_details(booking_id: int) -> BookingDetails | None:
  """Gets the details of a given booking by id"""
  with create_connection() as conn:
    cursor = conn.cursor()

    cursor.execute("""
      SELECT b.booking_id, b.status, b.booking_date, b.user_id,
              s.session_id, pmt.cost,
              s.sType, s.date_time,
              pl.name, s.lane_number, l.status,
              per.name, s.max_capacity,
              (SELECT COUNT(*) FROM municipal.has h2
              JOIN municipal.booking b2 ON h2.booking_id = b2.booking_id
              WHERE h2.session_id = s.session_id) AS booked_count
      FROM municipal.booking b
      JOIN municipal.has h ON b.booking_id = h.booking_id
      JOIN municipal.sessionn s ON h.session_id = s.session_id
      JOIN municipal.instructor i ON s.instructor_id = i.instructor_id
      JOIN municipal.person per ON i.person_id = per.person_id
      JOIN municipal.pool pl ON s.pool_id = pl.pool_id
      JOIN municipal.lane l ON s.pool_id = l.pool_id AND s.lane_number = l.lane_number
      LEFT JOIN municipal.payment pmt ON pmt.user_id = b.user_id
      WHERE b.booking_id = ?
    """, (booking_id,))

    row = cursor.fetchone()
    if row:
      return BookingDetails(*row)
    return None
