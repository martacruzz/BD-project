import configparser
import functools
import os
from pathlib import Path

import pyodbc


@functools.cache
def conn_string() -> str:
    config_file = Path("conf.ini")
    assert config_file.exists(), "conf.ini file not found"

    config = configparser.ConfigParser(os.environ) # so that we can access the environment variable that holds the SQL password
    config.read(config_file)

    server = config["database"]["server"]
    db_name = config["database"]["name"]
    username = config["database"]["username"]
    password = config["database"]["password"]

    return (
    f"DRIVER={{ODBC Driver 18 for SQL Server}};" # change DRIVER={{ODBC Driver 18 for SQL Server}} if on mac
    f"SERVER={server};"
    f"DATABASE={db_name};"
    f"UID={username};"
    f"PWD={password};"
    f"Encrypt=yes;"
    f"TrustServerCertificate=yes;" # use only for projects, do not use for production
)


def create_connection():
    my_conn_string = conn_string()
    return pyodbc.connect(my_conn_string)

# to see if it connected
if __name__ == "__main__":
    print(conn_string())
    print(create_connection())
