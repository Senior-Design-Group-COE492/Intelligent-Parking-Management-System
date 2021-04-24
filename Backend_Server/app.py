import pandas as pd
import numpy as np
import datetime as dt
from flask import Flask, jsonify,request,make_response
from math import sin, cos, sqrt, atan2, radians
from pytz import timezone
from firebase_admin import credentials,firestore
from parking import Parking
import time, json, threading, os, requests, firebase_admin
#initializing the sdk
default_app = firebase_admin.initialize_app()

app = Flask(__name__)
app.config.from_object("config")

@app.route("/")
def main():
    print("server running")
    parking = Parking()
    #result = parking.initializeLocations()   ##ONLY UNCOMMENT THIS WHEN YOU WANT TO RESET THE PARKING LOCATIONS COLLECTION
    #start thread for prediction
    
    #start thread that constantly updates the current parking every minute
    currentAvailabilityThread = threading.Thread(target = parking.updateCurrentAvailability)
    currentAvailabilityThread.daemon = True
    currentAvailabilityThread.start()

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
