from typing import NamedTuple
from datetime import datetime
from persistence.session import create_connection


class SessionDescriptor(NamedTuple):
  session_id: int
  sType: str
  date_time: str
  instructor_name: str
  pool_name: str
  lane_number: int
  lane_status: str


class SessionDetails(NamedTuple):
  session_id: int
  duration: int
  date_time: str
  sType: str
  max_capacity: int
  instructor_id: int
  instructor_name: str
  lane_number: int
  lane_status: str
  pool_id: int
  pool_name: str


def list_all() -> list[SessionDescriptor]:
  """Lists all sessions in the db"""
  with create_connection() as conn:
    cursor = conn.cursor()
    
    cursor.execute("""
      SELECT s.session_id, s.sType, s.date_time,
              p.name AS instructor_name,
              pl.name AS pool_name,
              s.lane_number, l.status AS lane_status
      FROM municipal.sessionn s
      JOIN municipal.instructor i ON s.instructor_id = i.instructor_id
      JOIN municipal.person p ON i.person_id = p.person_id
      JOIN municipal.pool pl ON s.pool_id = pl.pool_id
      JOIN municipal.lane l ON s.pool_id = l.pool_id AND s.lane_number = l.lane_number
      ORDER BY s.date_time;
    """)

    return [SessionDescriptor(*row) for row in cursor.fetchall()]

def filter_sessions(sType: str = None, instructor_name: str = None, duration_min: int = None, duration_max: int = None, search_date: str = None) -> list[SessionDescriptor]:
  """Lists all sessions that apply with a certain filter"""

  with create_connection() as conn:
    cursor = conn.cursor()
    
    cursor.execute("""
      select 
        session_id,
        sType,
        date_time,
        instructor_name,
        pool_name,
        lane_number,
        lane_status
      from municipal.SearchSessions(?, ?, ?, ?, ?)
      order by date_time;
    """, (sType, instructor_name, duration_min, duration_max, search_date))

    rows = cursor.fetchall()

    if not rows:
      return []

    return [SessionDescriptor(*row) for row in rows]




def read(session_id: int) -> SessionDetails | None:
  """Get a given session's details by session id"""
  with create_connection() as conn:
    cursor = conn.cursor()
    cursor.execute("""
      SELECT s.session_id, s.duration, s.date_time, s.sType,
              s.max_capacity, s.instructor_id, p.name AS instructor_name,
              s.lane_number, l.status AS lane_status,
              s.pool_id, pl.name AS pool_name
      FROM municipal.sessionn s
      JOIN municipal.instructor i ON s.instructor_id = i.instructor_id
      JOIN municipal.person p ON i.person_id = p.person_id
      JOIN municipal.pool pl ON s.pool_id = pl.pool_id
      JOIN municipal.lane l ON s.pool_id = l.pool_id AND s.lane_number = l.lane_number
      WHERE s.session_id = ?;
    """, session_id)

    row = cursor.fetchone()
    if row:
        return SessionDetails(*row)
    return None