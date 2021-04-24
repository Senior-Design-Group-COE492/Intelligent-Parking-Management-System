### contains method parkings ###
import pandas as pd
import numpy as np
import os
import json
from math import sin, cos, sqrt, atan2, radians
from pytz import timezone
from neural_network import NN
import firebase_admin
from firebase_admin import credentials,firestore

class Parking:
    def __init__(self):
        info_df = pd.read_csv('hdb-carpark-information-with-lat-lng.csv')
        nn = NN()
        df = nn.getCurrentAvailability()
        self.info_df = pd.merge(df, info_df, left_on=['carpark_number'], right_on=['carpark_number'])
        self.parkings = self.info_df[['carpark_number','lat','lng','night_parking','free_parking','car_park_type','type_of_parking_system']]
        self.db = firestore.client()

    def initializeLocations(self):
        
        #for every record in the df, store it in the parking_info collection using the parking ID as document ID
        parking = self.info_df.set_index('carpark_number').T.to_json()
        parking = json.loads(parking)
        #sending the array to firestored
        data = {
            u'parking' : parking
        }
        db.collection(u'parking_info').document('parkings').set(data)

        #return true after you're done

        return (True,)
    
    def updateCurrentAvailability(self):
        parking = nn.getCurrentAvailability()
        parking = self.info_df.set_index('carpark_number')[['lots_available']].T.to_json()
        parking = json.loads(parking)
        data = {
            u'current_availability' : parking
        }
        db.collection(u'parking_info').document('parkings').set(data)


    
    def DistCalc(self,latitude,longtitude):
        R = 6373.0
        location = []
        lattemp=latitude
        lontemp=longtitude
        j=0
        for i in range(len(self.parkings.lat)):
            lat1=radians(self.parkings.lat[i])
            lon1=radians(self.parkings.lng[i])
            lat2=radians(lattemp)
            lon2=radians(lontemp)
            dlon = lon2 - lon1
            dlat = lat2 - lat1
            a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
            c = 2 * atan2(sqrt(a), sqrt(1 - a))
            distance = R * c
            if(distance<1.0000):
                location.append(self.parkings.carpark_number[i])
                print(location[j])
                j+=1
        return location
    
    def getFilteredParkings(self,lat,lon,night_parking,free_parking,car_park_type,type_of_parking_system):
        nn=NN()
        df=nn.getCurrentAvailability()
        df=pd.merge(df, self.parkings, left_on=['carpark_number'], right_on=['carpark_number'])

        id=self.DistCalc(lat,lon)
        filtparkings=df[(df['night_parking']==night_parking) & (df['free_parking']==free_parking) &(df['car_park_type'].isin(car_park_type)) & (df['type_of_parking_system']==type_of_parking_system)]
        filteredparkings=filtparkings[filtparkings['carpark_number'].isin(id)]
        print(filteredparkings)
        res=filteredparkings[['carpark_number','lat','lng','lots_available']].set_index('carpark_number').T.to_json()
        return res

    def generatePrediction():
        list_of_predictions = NN.generateEverything()
        #loop through the predictions
