### contains method parkings ###
import pandas as pd
import numpy as np
import os
from math import sin, cos, sqrt, atan2, radians
from pytz import timezone
from neural_network import NN
import firebase_admin
from firebase_admin import credentials,firestore

class Parking:
    def __init__(self):
        self.info_df = pd.read_csv('hdb-carpark-information-with-lat-lng.csv')
        self.parkings = self.info_df[['CarParkID','lat','lng','night_parking','free_parking','car_park_type','type_of_parking_system']]

    def initializeLocations(self):
        
        db = firestore.client()
        #for every record in the df, store it in the parking_info collection using the parking ID as document ID
        parking = {}
        #turned it into an array of hashmaps of hashmaps of the parking info such that the car_park_id of the location is the key and
        #the value is an array of the rest of the parking details hashmaps 
        for i in range (0,len(info_df)):
            parking[str(info_df.iloc[i][1])] = [
                {u'address': str(info_df.iloc[i][2])},
                {u'car_park_type': str(info_df.iloc[i][3])},
                {u'type_of_parking_system': str(info_df.iloc[i][4])},
                {u'short_term_parking': str(info_df.iloc[i][5])},
                {u'free_parking': False if info_df.iloc[i][6] == 'NO' else True},
                {u'night_parking': True if info_df.iloc[i][7] == 'YES' else False},
                {u'car_park_decks': str(info_df.iloc[i][8])},
                {u'gantry_height': str(info_df.iloc[i][9])},
                {u'car_park_basement': True if info_df.iloc[i][10] == 'Y' else False},
                {u'location': (info_df.iloc[0][11] , info_df.iloc[i][12])}
            ]
        #sending the array to firestore
        data = {
            u'parking' : parking
        }
        db.collection(u'parking_info').document('parkings').set(data)

        #return true after you're done

        return (True,)
    
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
                location.append(self.parkings.CarParkID[i])
                print(location[j])
                j+=1
        return location
    
    def getFilteredParkings(self,lat,lon,night_parking,free_parking,car_park_type,type_of_parking_system):
        nn=NN()
        df=nn.getCurrentAvailability()
        df=pd.merge(df, self.parkings, left_on=['carpark_number'], right_on=['CarParkID'])

        id=self.DistCalc(lat,lon)
        filtparkings=df[(df['night_parking']==night_parking) & (df['free_parking']==free_parking) &(df['car_park_type'].isin(car_park_type)) & (df['type_of_parking_system']==type_of_parking_system)]
        filteredparkings=filtparkings[filtparkings['CarParkID'].isin(id)]
        print(filteredparkings)
        res=filteredparkings[['CarParkID','lat','lng','lots_available']].set_index('CarParkID').T.to_json()
        return res

    def generatePrediction():
        list_of_predictions = NN.generateEverything()
        #loop through the predictions
