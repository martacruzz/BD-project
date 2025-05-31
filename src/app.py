import datetime
import hashlib
from flask import Flask, render_template, request, make_response, g

from routes.bookings import bp as bookings_bp
from routes.sessions import bp as sessions_bp
from routes.balance import bp as balance_bp

from persistence import user

app = Flask(__name__)
app.register_blueprint(bookings_bp)
app.register_blueprint(sessions_bp)
app.register_blueprint(balance_bp)

# dummy user login
@app.before_request
def load_dummy_user():
    dummy_user_id = 1 
    g.user = user.read(dummy_user_id)


@app.route("/")
def home():
    if not g.user:
      return "Unauthorized", 401 

    bookings = user.get_user_bookings(g.user.user_id)
    return render_template("user/user.html", bookings=bookings, user=g.user)



























# ## form to add a new user
# @app.route("/users/new", methods=["GET"])
# def new_user():
#     return render_template("user/new_user_form.html")

# ## post a new user
# @app.route("/users", methods=["POST"])
# def post_user():
#     data = request.form # grab all the form data submitted in the post request
#     user_id = user.generate_user_id(data.get('username'), data.get('cc'))

#     # form fields
#     name = data.get('name')
#     email = data.get('email')
#     phone = int(data.get('phone') or 0)
#     date_of_birth = data.get('date_of_birth')
#     age = int(data.get('age') or 0)
#     address = data.get('address')
#     cc = int(data.get('cc') or 0)
#     nif = int(data.get('nif') or 0)

#     # For now, let's use email as username and hash it as password -- change this later
#     username = email
#     password_hash = hashlib.sha256(username.encode()).hexdigest()


#     registration_date = datetime.datetime.now().strftime("%Y-%m-%d")

#     new_user = user.UserDetails(
#         user_id=user_id,
#         cc=cc,
#         registration_date=registration_date,
#         balance=0,  # default 
#         nif=nif,
#         username=username,
#         password_hash=password_hash,
#         name=name,
#         email=email,
#         phone=phone,
#         date_of_birth=date_of_birth,
#         age=age,
#         address=address

#     )

#     try:
#         user.create(new_user)
#         response = make_response()
#         print("ADD: new user added")
#         print(new_user)
#     except Exception as e:
#         warning_message = (
#             str(e.args[1]).split("(50000)")[-2].split("]")[-1].strip()
#             if len(e.args) > 1 and "(50000)" in str(e.args[1])
#             else str(e)
# )
#         response = make_response(render_template("person/new_person_form.html", user=new_user, warning=warning_message))
#         print(e)
#         print("ERROR: error creating user")
#         print(new_user)

#     # to refresh the page automaticallys
#     response.headers["HX-Trigger"] = "refreshUserList"
#     return response  

# # # persons
# # @app.route("/persons")
# # def persons():
# #     persons = person.list_all()
# #     return render_template("person/person.html", persons=persons)

# # # form to create a new person
# # @app.route("/persons/new", methods=["GET"])
# # def new_author():
# #     return render_template("person/new_person_form.html")


if __name__ == "__main__":
    app.run(debug=True)
