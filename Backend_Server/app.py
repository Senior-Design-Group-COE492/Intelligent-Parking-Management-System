from flask import Flask, jsonify
import os
import firebase_admin
from firebase_admin import credentials,firestore

from parking import Parking
app = Flask(__name__)
app.config.from_object("config")

#initializing the sdk
default_app = firebase_admin.initialize_app()

## not using this to auth because OAuth 2.0 tokens are not supported with  firestore
#cred = credentials.Certificate("parkingapp-6ecfd-firebase-adminsdk-4dxe4-9280754b4c.json")
#firebase_admin.initialize_app(cred)
#db = firestore.client()

@app.route("/")
def main():
    print("server running")
    #result = Parking.initializeLocations()   ##ONLY UNCOMMENT THIS WHEN YOU WANT TO RESET THE PARKING LOCATIONS COLLECTION
    result = True
    #start thread forr prediction
    return jsonify(success = result)

###Parking methods###

#retrieve filtered parkings
@app.route("/parking",methods = ["GET"])
def getParking():
    pass

######################