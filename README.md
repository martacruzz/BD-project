# SwiM - A municipal pool management app

Simple Flask webapp project backed by SQL Server.

## Dependencies

- Python3.8+ and SQL Server.
- Poetry (for dependency management)
- Libraries
  - [Flask](https://flask.palletsprojects.com)
  - Pyodbc
  - [htmx](https://htmx.org) (included in index.html)

Dependencies can be managed using [Poetry](https://python-poetry.org/). 
To install Poetry, follow the [installation guide](https://python-poetry.org/docs/#installing-with-the-official-installer).
Make sure you add Poetry to your path (section 3 of the guide).

Then install the project dependencies with: `poetry install`.

You can then use: `poetry run ....` or open `poetry shell` to run your project.
If you use poetry shell, then run `python app.py` to execute the app.

## Running

Make sure you define these 2 environment variables: 
- export FLASK_APP = app.py
- export SQL_PASSWORD="[your server's password]"  

If not on a virtual environemnt open one with: `poetry shell`

To run the application, use the following command: `flask run --debug`

Also, if not running on linux (with SQL DRIVER: ODBC Driver 18 for SQL Server), change this line in persistence/session.py to {{SQL Server}}