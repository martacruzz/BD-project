from flask import Flask, render_template
from persistence.person import list_all

app = Flask(__name__)


@app.route("/")
def index():
    persons = list_all()
    return render_template("index.html", persons=persons)


if __name__ == "__main__":
    app.run(debug=True)
