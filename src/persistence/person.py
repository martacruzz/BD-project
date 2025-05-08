import sys
sys.path.append('.')
import random
import string
from typing import NamedTuple

from pyodbc import IntegrityError

from persistence.session import create_connection


class PersonDescriptor(NamedTuple):
    cc: int
    name: str


class PersonDetails(NamedTuple):
    cc: str
    name: str
    email: str
    phone: int
    date_of_birth: str
    age: int
    address: str


def list_all() -> list[PersonDescriptor]:
    with create_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT cc, name FROM municipal.person;")

        return list(map(lambda row: PersonDescriptor(row.cc, row.name), cursor))


def read(person_cc: int):
    with create_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM municipal.person WHERE cc = ?;", person_cc)
        row = cursor.fetchone()

        return row.cc, PersonDetails(
            row.name,
            row.email or "",
            row.phone or "",
            row.date_of_birth or "",
            row.age or "",
            row.address or "",
            "",
            "",
        )


def create(person: PersonDetails):

    with create_connection() as conn:
        cursor = conn.cursor()
        cursor.execute(
            """
            INSERT INTO municipal.person(
                cc, name, email, phone, 
                date_of_birth, age, address) 
            VALUES (?, ?, ?, ?, ?, ?, ?);
            """,
            person.cc,
            person.name,
            person.email,
            person.phone,
            person.date_of_birth,
            person.age,
            person.address,
        )

        cursor.commit()


# TODO
def update(person_cc: int, person: PersonDetails):
    raise NotImplementedError()


def delete(person_cc: int):
    with create_connection() as conn:
        cursor = conn.cursor()
        try:
            cursor.execute("DELETE municipal.person WHERE cc = ?;", person_cc)
            cursor.commit()
        except IntegrityError as ex:
            if ex.args[0] == "23000":
                raise Exception(f"Person {person_cc} cannot be deleted. Probably has orders.") from ex
