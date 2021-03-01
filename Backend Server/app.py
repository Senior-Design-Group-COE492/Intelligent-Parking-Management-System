from flask import Flask, firebase_admin, os, jsonify
from firebase_admin import credentials

app = Flask(__name__)
app.config.from_object("config")


#initializing the sdk
default_app = firebase_admin.initialize_app()

## not using this to auth because OAuth 2.0 tokens are not supported with  firestore
#cred = credentials.Certificate("parkingapp-6ecfd-firebase-adminsdk-4dxe4-9280754b4c.json")
#firebase_admin.initialize_app(cred)

@app.route("/")
def main():
    print("server running")
    return jsonify(success = True)

###Parking methods###

#retrieve filtered parkings
@app.route("/parking",methods = ["GET"])
def getParking():
    pass

#update parking info on firebase
@app.route("/parking",methods = ["PATCH"])
def updateParking():
    pass

######################

##Prediction methods##
@app.route("/predict",methods = ["GET"])
def getPrediction():
    pass



# @app.route("/editUser", methods = ["POST","GET"])
# def updateUser():
#     pass