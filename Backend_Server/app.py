from flask import Flask, jsonify,request,make_response
import os
import requests
import pandas as pd
import numpy as np
import datetime as dt
import time
import json
from math import sin, cos, sqrt, atan2, radians
from pytz import timezone
import firebase_admin
from firebase_admin import credentials,firestore
from parking import Parking

#initializing the sdk
default_app = firebase_admin.initialize_app()

## not using this to auth because OAuth 2.0 tokens are not supported with  firestore
#cred = credentials.Certificate("parkingapp-6ecfd-firebase-adminsdk-4dxe4-9280754b4c.json")
#firebase_admin.initialize_app(cred)

#db = firestore.client()

app = Flask(__name__)
app.config.from_object("config")

@app.route("/")
def main():
    print("server running")
    #parking = Parking()
    #result = parking.initializeLocations()   ##ONLY UNCOMMENT THIS WHEN YOU WANT TO RESET THE PARKING LOCATIONS COLLECTION
    #start thread for prediction
    
    #start thread that constantly updates the current parking every minute

    result = True
    return jsonify(success = result)

#retrieve filtered parkings
@app.route("/filterParkings",methods = ["POST"])
def getParking():
    if request.is_json:
        req=request.get_json()
        parking = Parking()
        result = parking.getFilteredParkings(req.get('lat'),req.get('lon'),req.get('night_parking'),req.get('free_parking'),req.get('car_park_type'),req.get('type_of_parking_system'))
        return jsonify(success = True, results = result)
    return jsonify(success = False,error = "PAIN")
######################