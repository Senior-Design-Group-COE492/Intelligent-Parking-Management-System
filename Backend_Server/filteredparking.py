import requests
import pandas as pd
import numpy as np
import datetime as dt
import time
import json
from flask import Flask,request, jsonify,make_response
import os
from math import sin, cos, sqrt, atan2, radians
from pytz import timezone
info_df = pd.read_csv('D:\SeniorProject\Intelligent-Parking-Management-System\Backend Server\hdb-carpark-information-with-lat-lng.csv')
app = Flask(__name__)
# approximate radius of earth in km
R = 6373.0
parkings = info_df[['CarParkID','lat','lng','night_parking','free_parking','car_park_type','type_of_parking_system']]
def getCurrentAvailability(info_df=pd.DataFrame()):
    # gets current availability from Singapore Government's 'Carpark Availability' API
    response = requests.get('https://api.data.gov.sg/v1/transport/carpark-availability')
    parking_availability = response.json()['items'][0]
    timestamp = parking_availability['timestamp']
    df = pd.DataFrame(parking_availability['carpark_data'])
    # Seperate info into arrays, as pandas isn't seperating them properly
    total_lots = []
    lot_type = []
    lots_available = []
    for carpark_info in parking_availability['carpark_data']:
        total_lots.append(carpark_info['carpark_info'][0]['total_lots'])
        lot_type.append(carpark_info['carpark_info'][0]['lot_type'])
        lots_available.append(carpark_info['carpark_info'][0]['lots_available'])
    # Add the new columns and delete the unneeded one
    df['total_lots'] = total_lots
    df['lot_type'] = lot_type
    df['lots_available'] = lots_available
    df = df.drop(['carpark_info'], axis=1)
    return df

df = getCurrentAvailability()
info_df = pd.read_csv('hdb-carpark-information-with-lat-lng.csv')
# merges the availability dataframe with the iformation dataframe
merged_df = pd.merge(df, info_df, left_on=['carpark_number'], right_on=['CarParkID']).drop(['CarParkID', 'Unnamed: 0'], axis=1)
#count for coordinates added
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

@app.route("/filter",methods=["POST"])
def filter():
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
if __name__ == "__main__":
    app.run(host = '127.0.0.1', port = 5030) 

