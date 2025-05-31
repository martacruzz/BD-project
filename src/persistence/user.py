import hashlib
from typing import NamedTuple
from pyodbc import IntegrityError
from persistence.session import create_connection


class UserDescriptor(NamedTuple):
    user_id: int
    username: str
    cc: int
    name: str # comes from person


class UserDetails(NamedTuple):
    user_id: int
    cc: int
    registration_date: str
    balance: int
    nif: int
    username: str
    password_hash: str
    
    # person attributes
    name: str
    email: str
    phone: int
    date_of_birth: str
    age: int
    address: str


def list_all() -> list[UserDescriptor]:
    with create_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("""
                       select u.user_id, u.username, u.person_id, p.name
                       from municipal.app_user as u
                       join municipal.person as p
                       on u.person_id = p.person_id 
                  """)

        return list(map(lambda row: UserDescriptor(row.user_id, row.username, row.person_id, row.name), cursor))


def read(user_id: int):
    with create_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("""
                       select u.user_id, u.person_id, u.registration_date, u.balance, u.nif, u.username, u.password_hash,
                       p.name, p.email, p.phone, p.date_of_birth, p.age, p.address
                       from municipal.app_user as u
                       join municipal.person as p
                       on u.person_id = p.person_id
                       where user_id = ?;
                  """, user_id)
        row = cursor.fetchone()

        if row == None:
            return None

        return UserDetails(
            row.user_id,
            row.person_id,
            row.registration_date or "",
            row.balance or 0,
            row.nif or 0,
            row.username,
            row.password_hash,
            row.name,
            row.email or "",
            row.phone or 0,
            row.date_of_birth or "",
            row.age or 0,
            row.address or ""
        )


# def create(user: UserDetails):

#     with create_connection() as conn:
#         cursor = conn.cursor()

#         # insert into person
#         cursor.execute(
#             """
#               insert into municipal.person (cc, name, email, phone, date_of_birth, age, address)
#               values (?, ?, ?, ?, ?, ?, ?);
#             """,
#             user.person_id,
#             user.name,
#             user.email,
#             user.phone,
#             user.date_of_birth,
#             user.age,
#             user.address
#         )

#         # insert into app_user
#         cursor.execute(
#             """
#               insert into municipal.app_user (user_id, cc, registration_date, balance, nif, username, password_hash)
#               values (?, ?, ?, ?, ?, ?, ?)
#             """,
#             user.user_id,
#             user.person_id,
#             user.registration_date,
#             user.balance,
#             user.nif,
#             user.username,
#             user.password_hash
#         )

#         cursor.commit()


# TODO
def update(user_id: int, user: UserDetails):
    raise NotImplementedError()


def delete(user_id: int):
    with create_connection() as conn:
        cursor = conn.cursor()
        try:
            # fetch user's cc by joining app_user with person
            cursor.execute("select cc from municipal.app_user where user_id = ?", user_id)
            row = cursor.fetchone()
            user_cc = row.person_id
            
            # delete from app_user
            cursor.execute("delete from municipal.app_user where user_id = ?", user_id)

            # delete from person (?) -- maybe don't add this as we can have people that can be users and lifeguards/instructors
            # cursor.execute("delete from municipal.person where cc = ?", user_cc)

            cursor.commit()
        except IntegrityError as ex:
            if ex.args[0] == "23000":
                raise Exception(f"User {user_id} cannot be deleted.") from ex

def authenticate(username: str, password: str) -> UserDescriptor | None:
    """Authenticates a given user with their username and hashed password"""

    with create_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("""
            select u.user_id, u.username, p.cc, p.name, u.password_hash
            from municipal.app_user as u
            join municipal.person as p on u.person_id = p.person_id
            where u.username = ?
        """, username)

        row = cursor.fetchone()
        if row and hashlib.sha256(password.encode()).hexdigest() == row.password_hash:
            return UserDescriptor(row.user_id, row.username, row.cc, row.name)
        return None
    
# TODO aqui maybe mete um procedure
def get_user_bookings(user_id: int):
    """Get all bookings under the name of a given user"""
    with create_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("""
            select b.booking_id, b.status, b.booking_date,
                   s.session_id, s.date_time, s.sType, s.duration, s.max_capacity,
                   i.instructor_id, p.name as instructor_name,
                   s.lane_number, s.pool_id
            from municipal.booking b
            join municipal.has h on b.booking_id = h.booking_id
            join municipal.sessionn s on h.session_id = s.session_id
            join municipal.instructor i on s.instructor_id = i.instructor_id
            join municipal.person p on i.person_id = p.person_id
            where b.user_id = ?
        """, user_id)
        return cursor.fetchall()


