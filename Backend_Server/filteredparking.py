import pandas as pd
import numpy as np
import datetime as dt
import time
import json
from flask import Flask,request, jsonify,make_response
import os
from math import sin, cos, sqrt, atan2, radians
from pytz import timezone
from neural_network import NN
info_df = pd.read_csv('D:\SeniorProject\Intelligent-Parking-Management-System\Backend_Server\hdb-carpark-information-with-lat-lng.csv')
#id_df = pd.read_csv('D:\SeniorProject\Intelligent-Parking-Management-System\Backend_Server\selected_carparks.csv')
app = Flask(__name__)
# approximate radius of earth in km
R = 6373.0
parkings = info_df[['CarParkID','lat','lng','night_parking','free_parking','car_park_type','type_of_parking_system']]
NN=NN()
df=NN.getCurrentAvailability()
df=pd.merge(df, parkings, left_on=['carpark_number'], right_on=['CarParkID'])
#df=df[df['CarParkID']==id_df['carpark_number']]
no=[]
location=[]
def DistCalc(latitude,longtitude,dis):
    lattemp=latitude
    lontemp=longtitude
    j=0
    distance1=dis
    for i in range(len(parkings.lat)):
        lat1=radians(parkings.lat[i])
        lon1=radians(parkings.lng[i])
        lat2=radians(lattemp)
        lon2=radians(lontemp)
        dlon = lon2 - lon1
        dlat = lat2 - lat1
        a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
        c = 2 * atan2(sqrt(a), sqrt(1 - a))
        distance0 = R * c
        if(distance0<distance1):
            location.append(parkings.CarParkID[i])
            print(location[j])
            j+=1
    return location

@app.route("/filter",methods=["POST"])
def filter():
    if request.is_json:
        req=request.get_json()
        id=DistCalc(req.get("lat"),req.get("lon"),req.get("distance"))
        if req.get("night_parking")!=None:
            filtparkings=df[(df['night_parking']==req.get("night_parking"))]
        if req.get("free_parking")!=None:
            filtparkings=df[(df['free_parking']==req.get("free_parking"))]
        if req.get("car_park_type")!=None:
            filtparkings=df[(df['car_park_type'].isin(req.get("car_park_type")))]
        if req.get("type_of_parking_system")!=None:
            filtparkings=df[(df['type_of_parking_system']==req.get("type_of_parking_system"))]
        filteredparkings=filtparkings[filtparkings['CarParkID'].isin(id)]
        #filtparkings=df[(df['night_parking']==req.get("night_parking")) & (df['free_parking']==req.get("free_parking")) & (df['car_park_type'].isin(req.get("car_park_type"))) & (df['type_of_parking_system']==req.get("type_of_parking_system"))]
        print(filteredparkings)
        res=filteredparkings[['CarParkID','lat','lng','lots_available']].set_index('CarParkID').T.to_json()
        return res
    else:
        res=make_response(jsonify({"message":"No JSON received"}),400)
        return res
if __name__ == "__main__":
    app.run(host = '127.0.0.1', port = 5030) 
