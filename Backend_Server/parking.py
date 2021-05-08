### contains method parkings ###
import pandas as pd
import numpy as np
import os, json, time
import firebase_admin
from firebase_admin import credentials,firestore
from math import sin, cos, sqrt, atan2, radians
from pytz import timezone
from neural_network import NN
from tensorflow.keras.models import load_model
class Parking:
    def __init__(self):
        info_df = pd.read_csv('hdb-carpark-information-with-lat-lng.csv')
        self.nn = NN()
        df = self.nn.getCurrentAvailability()
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
        self.db.collection(u'parkingsinfo').document('parkings').set(data)

        #return true after you're done

        return (True,)
    
    def updateCurrentAvailability(self):
        next_call = time.time()
        while True:
            print("getting current availability")
            parking = self.nn.getCurrentAvailability()
            parking = self.info_df.set_index('carpark_number')[['lots_available']].T.to_json()
            parking = json.loads(parking)
            data = {
                u'current_availability' : parking
            }
            self.db.collection(u'parking_info').document('parkings').set(data)
            print("pushed to db")
            next_call+= 60
            print("sleeping")
            time.sleep(next_call -time.time())


    
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

    def generateSequencePrediction(self):
        next_call = time.time()
        while True:
            df_list = self.nn.getSequenceFromCurrentTime()
            self.df_list_for_nn = self.nn.modifyDataframeListForNN(df_list)
            predictions = {}
            #generate prediction
            for df in self.df_list_for_nn:
                model = self.models[df.carpark_number.iloc[0]]
                prediction = self.nn.generatePrediction(model,df)
                prediction = prediction[0].tolist
                # for i in range len(prediction):
                #     prediction[i] = prediction[i]*
                predictions[df.carpark_number.iloc[0]] = prediction
                print("[", df.carpark_number.iloc[0],"] = ",prediction)
            
            #push to firebase
            data = {
                u'predictions' : predictions
            }
            self.db.collection(u'parking_predictions').document('predictions').set(data)
            next_call+= 60*15 # every 15 minutes
            time.sleep(next_call -time.time())

    def loadModels(self):
        #read all the models from the folder
        #use this:
        self.models = {}
        directory = r"./trained_models/"
        for filename in os.listdir(directory):
            #load model
            model = load_model(directory+filename, custom_objects=None, compile=True, options=None)
            #get carpark id from filename
            filename_split = filename.split('_')
            carpark_id_split = filename_split[-1].split('.')
            carpark_id = carpark_id_split[0]

            #add model to dict with car_park id as key
            self.models[carpark_id] = model
            print("["+carpark_id+"]=\t")
            print(self.models[carpark_id])
            #model_checkpoint_ID.h5 as key and model as value in dict
