### contains method parkings ###
import pandas as pd
import numpy as np
from neural_network import NN
import firebase_admin
from firebase_admin import credentials,firestore

class Parking:

    def initializeLocations():
        info_df = pd.read_csv('hdb-carpark-information-with-lat-lng.csv')

        db = firestore.client()
        #for every record in the df, store it in the parking_info collection using the parking ID as document ID
        parking = []
        #turned it into an array of hashmaps of hashmaps of the parking info such that the car_park_id of the location is the key and
        # the value is an array of the rest of the parking details hashmaps 
        for i in range (0,len(info_df)):
            parking.append({
                str(info_df.iloc[i][1]):[ 
                {u'address': str(info_df.iloc[i][2])},
                {u'car_park_type': str(info_df.iloc[i][3])},
                {u'type_of_parking_system': str(info_df.iloc[i][4])},
                {u'short_term_parking': str(info_df.iloc[i][5])},
                {u'free_parking': False if info_df.iloc[i][6] == 'NO' else True},
                {u'night_parking': True if info_df.iloc[i][7] == 'YES' else False},
                {u'car_park_decks': str(info_df.iloc[i][8])},
                {u'gantry_height': str(info_df.iloc[i][9])},
                {u'car_park_basement': True if info_df.iloc[i][10] == 'Y' else False},
                {u'location': (info_df.iloc[0][11] , info_df.iloc[i][12])}]
            })
        
        #sending the array to firestore
        data = {
            u'parking' : parking
        }
        db.collection(u'parking_info').document('parkings').set(data)

        #return true after you're done
        return (True,)


    def generatePrediction():
        list_of_predictions = NN.generateEverything()
        #loop through the predictions
    
    def getFilteredParkings():
        pass
