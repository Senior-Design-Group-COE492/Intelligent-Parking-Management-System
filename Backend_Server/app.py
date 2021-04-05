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


info_df = pd.read_csv('hdb-carpark-information-with-lat-lng.csv')
R = 6373.0
parkings = info_df[['CarParkID','lat','lng','night_parking','free_parking','car_park_type','type_of_parking_system']]
no=[]
location=[]
def DistCalc(latitude,longtitude):
    lattemp=latitude
    lontemp=longtitude
    j=0
    for i in range(len(parkings.lat)):
        lat1=radians(parkings.lat[i])
        lon1=radians(parkings.lng[i])
        lat2=radians(lattemp)
        lon2=radians(lontemp)
        dlon = lon2 - lon1
        dlat = lat2 - lat1
        a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
        c = 2 * atan2(sqrt(a), sqrt(1 - a))
        distance = R * c
        if(distance<1.0000):
            location.append(parkings.CarParkID[i])
            print(location[j])
            j+=1
    return location


@app.route("/")
def main():
    print("server running")
    #result = Parking.initializeLocations()   ##ONLY UNCOMMENT THIS WHEN YOU WANT TO RESET THE PARKING LOCATIONS COLLECTION
    result = True
    #start thread forr prediction
    return jsonify(success = result)

###Parking methods###

#retrieve filtered parkings
@app.route("/parking",methods = ["POST"])
def getParking():
    if request.is_json:
        req=request.get_json()
        id=DistCalc(req.get("lat"),req.get("lon"))
        filtparkings=parkings[(parkings['night_parking']==req.get("night_parking")) & (parkings['free_parking']==req.get("free_parking")) & (parkings['car_park_type'].isin(req.get("car_park_type"))) & (parkings['type_of_parking_system']==req.get("type_of_parking_system"))]
        filteredparkings=filtparkings[filtparkings['CarParkID'].isin(id)]
        print(filteredparkings)
        res=filteredparkings[['CarParkID','lat','lng']].set_index('CarParkID').T.to_json()
        return res
    else:
        res=make_response(jsonify({"message":"No JSON received"}),400)
        return res

######################