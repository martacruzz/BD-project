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

# Uses Stored Procedure to create a user
def create(user: UserDetails):

    try:
        with create_connection() as conn:
            cursor = conn.cursor()

            # Create new user with stored procedure
            sql = """
            declare @new_person_id int, @new_user_id int;

            exec municipal.CreateUser
                @cc            = ?,
                @name          = ?,
                @email         = ?,
                @phone         = ?,
                @date_of_birth = ?,
                @address       = ?,
                @nif           = ?,
                @username      = ?,
                @password_hash = ?,
                @new_person_id = @new_person_id OUTPUT,
                @new_user_id   = @new_user_id OUTPUT;

            select
                @new_person_id as new_person_id,
                @new_user_id as new_user_id;

            """

            cursor.execute(
                sql,
                user.cc,
                user.name,
                user.email,
                user.phone,
                user.date_of_birth,
                user.address,
                user.nif,
                user.username,
                user.password_hash
            )

            # Fetch the result of selected
            row = cursor.fetchone()
            if row is None:
                # Shouldn't be happening
                raise RuntimeError("Stored Procedure didn't return new IDs")
            
            new_person_id, new_user_id = row.new_person_id, row.new_user_id

            # Commit transaction
            conn.commit()

            # Return the output (optional, since you kinda don't need it)
            return new_person_id, new_user_id
        
    except pyodbc.DatabaseError as ex:
        raise
    except Exception:
        raise


# TODO
def update(user_id: int, user: UserDetails):
    raise NotImplementedError()


# Uses procedure to delete user
def delete(user_id: int):
    with create_connection() as conn:
        cursor = conn.cursor()
        try:
            
            # Execute the stored procedure
            cursor.execute(
                "Exec municipal.deleteUser @user_id = ?;",
                user_id
            )

            conn.commit()

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
    
# Uses a procedure to get the user's bookings (only those in the future)
# This is not a history
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
    

    # and s.date_time > GETDATE()