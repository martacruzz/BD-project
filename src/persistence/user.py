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
                       select u.user_id, u.username, u.cc, p.name
                       from municipal.app_user as u
                       join municipal.person as p
                       on u.cc = p.cc 
                  """)

        return list(map(lambda row: UserDescriptor(row.user_id, row.username, row.cc, row.name), cursor))


def read(user_id: int):
    with create_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("""
                       select u.user_id, u.cc, u.registration_date, u.balance, u.nif, u.username, u.password_hash,
                       p.name, p.email, p.phone, p.date_of_birth, p.age, p.address
                       from municipal.app_user as u
                       join municipal.person as p
                       on u.cc = p.cc
                       where user_id = ?;
                  """, user_id)
        row = cursor.fetchone()

        if row == None:
            return None

        return UserDetails(
            row.user_id,
            row.cc,
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


def create(user: UserDetails):

    with create_connection() as conn:
        cursor = conn.cursor()

        # insert into person
        cursor.execute(
            """
              insert into municipal.person (cc, name, email, phone, date_of_birth, age, address)
              values (?, ?, ?, ?, ?, ?, ?);
            """,
            user.cc,
            user.name,
            user.email,
            user.phone,
            user.date_of_birth,
            user.age,
            user.address
        )

        # insert into app_user
        cursor.execute(
            """
              insert into municipal.app_user (user_id, cc, registration_date, balance, nif, username, password_hash)
              values (?, ?, ?, ?, ?, ?, ?)
            """,
            user.user_id,
            user.cc,
            user.registration_date,
            user.balance,
            user.nif,
            user.username,
            user.password_hash
        )

        cursor.commit()


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
            user_cc = row.cc
            
            # delete from app_user
            cursor.execute("delete from municipal.app_user where user_id = ?", user_id)

            # delete from person (?) -- maybe don't add this as we can have persons that can be users and lifeguards/instructors
            # cursor.execute("delete from municipal.person where cc = ?", user_cc)

            cursor.commit()
        except IntegrityError as ex:
            if ex.args[0] == "23000":
                raise Exception(f"User {user_id} cannot be deleted.") from ex

def generate_user_id(username: str, cc: int) -> str:
  # combine username and cc
    combined = f"{username}{cc}"

    # generate SHA-256 hash of the combined string
    hash_object = hashlib.sha256(combined.encode())
    
    # get the first 10 characters of the hex digest
    author_id = hash_object.hexdigest()[:10]
    return author_id