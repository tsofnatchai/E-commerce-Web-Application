import json
from flask import Flask, request, jsonify, session
from functools import wraps
import boto3, os
from elasticsearch import Elasticsearch

app = Flask(__name__)
app.secret_key = os.environ.get("FLASK_SECRET_KEY", "default-secret-key-for-dev-only")

# Initialize AWS Kinesis client
kinesis_client = boto3.client('kinesis', region_name='us-east-1')
KINESIS_STREAM_NAME = 'order-activity-stream'

# Initialize Elasticsearch client (adjust endpoint accordingly)
es_endpoint = os.environ.get("ELASTICSEARCH_ENDPOINT", "http://elasticsearch:9200")
es = Elasticsearch([es_endpoint])

# In-memory data stores for demo purposes
users = {
    "user1": {"password": "pass1", "id": 1},
    "user2": {"password": "pass2", "id": 2}
}
products = {}  # Product catalog store
orders = {}    # Order store

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'username' not in session:
            return jsonify({"error": "Authentication required"}), 401
        return f(*args, **kwargs)
    return decorated_function

@app.route("/")
def index():
    return "Welcome to the Flask E-commerce App!"

@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    username = data.get("username")
    password = data.get("password")
    if username in users and users[username]["password"] == password:
        session["username"] = username
        return jsonify({"message": "Logged in successfully."})
    return jsonify({"error": "Invalid credentials."}), 401

@app.route("/logout", methods=["POST"])
@login_required
def logout():
    session.pop("username", None)
    return jsonify({"message": "Logged out successfully."})

@app.route("/products", methods=["GET"])
def list_products():
    q = request.args.get("q")
    if q:
        response = es.search(
            index="products",
            body={"query": {"match": {"name": q}}}
        )
        hits = response.get("hits", {}).get("hits", [])
        results = [hit["_source"] for hit in hits]
        return jsonify(results)
    else:
        return jsonify(list(products.values()))

@app.route("/products", methods=["POST"])
@login_required
def add_product():
    data = request.get_json()
    product_id = str(len(products) + 1)
    product = {
        "id": product_id,
        "name": data.get("name"),
        "description": data.get("description"),
        "price": data.get("price")
    }
    products[product_id] = product
    es.index(index="products", id=product_id, document=product)
    return jsonify(product), 201

@app.route("/order", methods=["POST"])
@login_required
def create_order():
    data = request.get_json()
    order_id = str(len(orders) + 1)
    order = {
        "id": order_id,
        "user": session["username"],
        "items": data.get("items"),
        "status": "pending"
    }
    orders[order_id] = order
    kinesis_client.put_record(
        StreamName=KINESIS_STREAM_NAME,
        Data=json.dumps(order),
        PartitionKey=order["user"]
    )
    return jsonify(order), 201

@app.route("/order/<order_id>", methods=["PUT"])
@login_required
def update_order(order_id):
    if order_id not in orders:
        return jsonify({"error": "Order not found"}), 404
    data = request.get_json()
    orders[order_id]["status"] = data.get("status", orders[order_id]["status"])
    kinesis_client.put_record(
        StreamName=KINESIS_STREAM_NAME,
        Data=json.dumps(orders[order_id]),
        PartitionKey=orders[order_id]["user"]
    )
    return jsonify(orders[order_id])

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)




# import json
# from flask import Flask, request, jsonify, session
# from functools import wraps
# import boto3, os
# from elasticsearch import Elasticsearch
#
# app = Flask(__name__)
# app.secret_key = os.environ.get("FLASK_SECRET_KEY", "default-secret-key-for-dev-only")
#
# # Initialize AWS Kinesis client (ensure proper AWS credentials or IRSA are configured)
# kinesis_client = boto3.client('kinesis', region_name='us-east-1')
# KINESIS_STREAM_NAME = 'order-activity-stream'
#
# # Initialize Elasticsearch client (adjust endpoint accordingly)
# es_endpoint = os.environ.get("ELASTICSEARCH_ENDPOINT", "http://localhost:9200")
# es = Elasticsearch([es_endpoint])
#
#
# #es = Elasticsearch(['http://your-elasticsearch-endpoint:9200'])
#
# # In-memory data stores for demo purposes
# users = {
#     "user1": {"password": "pass1", "id": 1},
#     "user2": {"password": "pass2", "id": 2}
# }
# products = {}  # Product catalog store
# orders = {}    # Order store
#
# def login_required(f):
#     @wraps(f)
#     def decorated_function(*args, **kwargs):
#         if 'username' not in session:
#             return jsonify({"error": "Authentication required"}), 401
#         return f(*args, **kwargs)
#     return decorated_function
#
# @app.route("/login", methods=["POST"])
# def login():
#     data = request.get_json()
#     username = data.get("username")
#     password = data.get("password")
#     if username in users and users[username]["password"] == password:
#         session["username"] = username
#         return jsonify({"message": "Logged in successfully."})
#     return jsonify({"error": "Invalid credentials."}), 401
#
# @app.route("/logout", methods=["POST"])
# @login_required
# def logout():
#     session.pop("username", None)
#     return jsonify({"message": "Logged out successfully."})
#
# @app.route("/products", methods=["GET"])
# def list_products():
#     q = request.args.get("q")
#     if q:
#         response = es.search(
#             index="products",
#             body={"query": {"match": {"name": q}}}
#         )
#         hits = response.get("hits", {}).get("hits", [])
#         results = [hit["_source"] for hit in hits]
#         return jsonify(results)
#     else:
#         return jsonify(list(products.values()))
#
# @app.route("/products", methods=["POST"])
# @login_required
# def add_product():
#     data = request.get_json()
#     product_id = str(len(products) + 1)
#     product = {
#         "id": product_id,
#         "name": data.get("name"),
#         "description": data.get("description"),
#         "price": data.get("price")
#     }
#     products[product_id] = product
#     es.index(index="products", id=product_id, document=product)
#     return jsonify(product), 201
#
# @app.route("/order", methods=["POST"])
# @login_required
# def create_order():
#     data = request.get_json()
#     order_id = str(len(orders) + 1)
#     order = {
#         "id": order_id,
#         "user": session["username"],
#         "items": data.get("items"),  # List of product IDs
#         "status": "pending"
#     }
#     orders[order_id] = order
#     kinesis_client.put_record(
#         StreamName=KINESIS_STREAM_NAME,
#         Data=json.dumps(order),
#         PartitionKey=order["user"]
#     )
#     return jsonify(order), 201
#
# @app.route("/order/<order_id>", methods=["PUT"])
# @login_required
# def update_order(order_id):
#     if order_id not in orders:
#         return jsonify({"error": "Order not found"}), 404
#     data = request.get_json()
#     orders[order_id]["status"] = data.get("status", orders[order_id]["status"])
#     kinesis_client.put_record(
#         StreamName=KINESIS_STREAM_NAME,
#         Data=json.dumps(orders[order_id]),
#         PartitionKey=orders[order_id]["user"]
#     )
#     return jsonify(orders[order_id])
#
# if __name__ == "__main__":
#     app.run(host="0.0.0.0", port=5000)
