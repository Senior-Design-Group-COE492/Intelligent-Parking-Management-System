import requests
import pandas as pd
import numpy as np
import datetime as dt
import time
import os
from pytz import timezone


class NN:
    def getCurrentAvailability(self,info_df=pd.DataFrame()):
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
        df = df[df['lot_type'] == 'C']
        df.reset_index()
        return df

    def getSequenceFromCurrentTime(self,minutes_in_future=210, minute_increments=15):
        # creates a list of dataframes, that is
        # each taken from the api at minute_increments apart from each other
        # until the minutes_in_future is reached, then returns the list of dataframes
        response = requests.get('https://api.data.gov.sg/v1/transport/carpark-availability?date_time=2019-08-12T06%3A45%3A13')
        singapore_timezone = timezone('Asia/Singapore')
        parking_availability = response.json()['items'][0]
        timestamp = parking_availability['timestamp']
        df = pd.DataFrame(parking_availability['carpark_data'])
        # starting date of the sequence (adding 10 in case exception is thrown)
        start_date = dt.datetime.now(singapore_timezone) - dt.timedelta(minutes=minutes_in_future)
        # end date would be current date as it is the last availability in the sequence
        end_date = dt.datetime.now(singapore_timezone)
        start_date_time = start_date.strftime('%y-%m-%dT%H:%M:%S')
        end_date_time = end_date.strftime('%y-%m-%dT%H:%M:%S')
        # Getting all the dataframes
        date = start_date
        info_df = pd.read_csv('hdb-carpark-information-with-lat-lng.csv')
        n_iterations = 0
        df_list = []
        while(date <= end_date):
            try:
                request_string = 'https://api.data.gov.sg/v1/transport/carpark-availability?date_time=%s' % (date.strftime('20%y-%m-%dT%H:%M:%S'))
                print(request_string)
                response = requests.get(request_string)
                parking_availability = response.json()['items'][0]
                timestamp = parking_availability['timestamp']
                df = pd.DataFrame(parking_availability['carpark_data'])
                total_lots = []
                lot_type = []
                lots_available = []
                for carpark_info in parking_availability['carpark_data']:
                    total_lots.append(carpark_info['carpark_info'][0]['total_lots'])
                    lot_type.append(carpark_info['carpark_info'][0]['lot_type'])
                    lots_available.append(carpark_info['carpark_info'][0]['lots_available'])

                # Add year-month-day-hour-minutes-seconds columns
                df['year'] = date.year
                df['month'] = date.month
                df['day'] = date.day
                df['hour'] = date.hour
                df['minute'] = date.minute
                df['second'] = date.second
                # Add the new columns and delete the unneeded one
                df['total_lots'] = total_lots
                df['lot_type'] = lot_type
                df['lots_available'] = lots_available
                df = df.drop(['carpark_info'], axis=1)
                df = df[df['lot_type'] == 'C']
                df = pd.merge(df, info_df, left_on=['carpark_number'], right_on=['carpark_number'])
                df_list.append(df)
                print('date: ', date)
                print('count: ', df['carpark_number'].count(),'\n')
                n_iterations += 1
                date = date + dt.timedelta(minutes=15)
            except Exception as e:
                date = date + dt.timedelta(minutes=1)
                print(e)
        return df_list

    def addFeaturesToDataframe(self,combined_df_sorted):
        # converts DataSeries into int then does the sin and cos transformation of each time unit
        combined_df_sorted['month_sin'] = np.sin(combined_df_sorted['month'].astype(int).to_numpy() * 2 * np.pi / 12)
        combined_df_sorted['month_cos'] = np.cos(combined_df_sorted['month'].astype(int).to_numpy() * 2 * np.pi / 12)
        combined_df_sorted['day_sin'] = np.sin(combined_df_sorted['day'].astype(int).to_numpy() * 2 * np.pi / 7)
        combined_df_sorted['day_cos'] = np.cos(combined_df_sorted['day'].astype(int).to_numpy() * 2 * np.pi / 7)
        combined_df_sorted['hour_sin'] = np.sin(combined_df_sorted['hour'].astype(int).to_numpy() * 2 * np.pi / 24)
        combined_df_sorted['hour_cos'] = np.cos(combined_df_sorted['hour'].astype(int).to_numpy() * 2 * np.pi / 24)
        combined_df_sorted['minute_sin'] = np.sin(combined_df_sorted['minute'].astype(int).to_numpy() * 2 * np.pi / 60)
        combined_df_sorted['minute_cos'] = np.cos(combined_df_sorted['minute'].astype(int).to_numpy() * 2 * np.pi / 60)
        
    # FOR BACKEND
    def sortDataframeList(self,df, merge_with_info=False, info_df=pd.DataFrame()):
        # combines the df_list into one dataframe, then sorts it
        # if merge_with_info is set to True, then the sorted df 
        # is merged with the info_df that is passed to the function
        combined_df_sorted = df.sort_values(by=['carpark_number', 'update_datetime'])
        combined_df_sorted = combined_df_sorted[combined_df_sorted['lot_type'] == 'C']
        combined_df_grouped = combined_df_sorted.groupby('carpark_number', axis=0)
        count_df = combined_df_grouped.count()
        keys_to_drop = count_df[count_df['update_datetime'] < (count_df.max()[0]-100)].index.to_list()
        combined_df_sorted = combined_df_sorted[~combined_df_sorted['carpark_number'].isin(keys_to_drop)]   
        return combined_df_sorted

    # FOR BACKEND    
    def modifyDataframeListForNN(self,df_list):
        sorted_df = self.sortDataframeList(pd.concat(df_list))
        df_list_by_number = []
        self.addFeaturesToDataframe(sorted_df)
        combined_df_grouped = sorted_df.groupby('carpark_number', axis=0)
        df_list_by_number = list(combined_df_grouped)
        # Ignore the car park area and all take the dataframe
        df_list_by_number = [area_and_df[1] for area_and_df in df_list_by_number]
        return df_list_by_number
        
        def sortDataframeList(self,df_list, merge_with_info=False, info_df=pd.DataFrame()):
            # combines the df_list into one dataframe, then sorts it
            # if merge_with_info is set to True, then the sorted df 
            # is merged with the info_df that is passed to the function
            combined_df = pd.concat(df_list)
            combined_df_sorted = combined_df.sort_values(by=['carpark_number', 'update_datetime'])
            del combined_df
            combined_df_sorted = combined_df_sorted[combined_df_sorted['lot_type'] == 'C']
            combined_df_grouped = combined_df_sorted.groupby('carpark_number', axis=0)
            count_df = combined_df_grouped.count()
            keys_to_drop = count_df[count_df['update_datetime'] < (count_df.max()[0]-100)].index.to_list()
            combined_df_sorted = combined_df_sorted[~combined_df_sorted['carpark_number'].isin(keys_to_drop)]
            if (merge_with_info):
                combined_df_sorted = pd.merge(combined_df_sorted, info_df[['CarParkID','car_park_type', 'type_of_parking_system']], left_on=['carpark_number'], right_on=['CarParkID']).drop(['CarParkID'], axis=1).drop_duplicates()
            return combined_df_sorted

    # adding some extra features
    def addFeaturesToDataframe(self,combined_df_sorted):
        # adds cyclical data of month, day, hour and minute
        # converts DataSeries into int then does the sin and cos transformation of each time unit
        combined_df_sorted['month_sin'] = np.sin(combined_df_sorted['month'].astype(int).to_numpy() * 2 * np.pi / 12)
        combined_df_sorted['month_cos'] = np.cos(combined_df_sorted['month'].astype(int).to_numpy() * 2 * np.pi / 12)
        combined_df_sorted['day_sin'] = np.sin(combined_df_sorted['day'].astype(int).to_numpy() * 2 * np.pi / 7)
        combined_df_sorted['day_cos'] = np.cos(combined_df_sorted['day'].astype(int).to_numpy() * 2 * np.pi / 7)
        combined_df_sorted['hour_sin'] = np.sin(combined_df_sorted['hour'].astype(int).to_numpy() * 2 * np.pi / 24)
        combined_df_sorted['hour_cos'] = np.cos(combined_df_sorted['hour'].astype(int).to_numpy() * 2 * np.pi / 24)
        combined_df_sorted['minute_sin'] = np.sin(combined_df_sorted['minute'].astype(int).to_numpy() * 2 * np.pi / 60)
        combined_df_sorted['minute_cos'] = np.cos(combined_df_sorted['minute'].astype(int).to_numpy() * 2 * np.pi / 60)
        return combined_df_sorted
        
    def convertDataframeToList(self,df):
        # seperates grouping into seperate lists by parking area
        df_grouped = df.groupby('carpark_number', axis=0)
        df_list_by_number = list(df_grouped)
        # Ignore the car park area and all take the dataframe
        df_list_by_number = [area_and_df[1] for area_and_df in df_list_by_number]
        return df_list_by_number
    
    # FOR BACKEND
    def normalize(self,data,capacity):
        # normalize to a percentage (available/capacity)
        data_normalized = data / capacity
        return (data_normalized)

    # FOR BACKEND
    def generatePrediction(self,model, parking_area_df):
        features_selected = ['lots_available', 'hour_sin', 'hour_cos', 'day_sin', 'day_cos', 'minute_sin', 'minute_cos']
        parking_area_df['lots_available'] = parking_area_df['lots_available'].astype(int).to_numpy()
        capacity = int(parking_area_df['total_lots'].iloc[0])
        x = self.normalize(parking_area_df[features_selected].to_numpy(),capacity)
        x = x.reshape(1, x.shape[0], len(features_selected))
        y = model.predict(x)
        return y*capacity


    # def generateEverything(self):
    #     info_df = pd.read_csv('hdb-carpark-information-with-lat-lng.csv')
    #     df = getCurrentAvailability()
    #     # merges the availability dataframe with the iformation dataframe
    #     merged_df = pd.merge(df, info_df, left_on=['carpark_number'], right_on=['carpark_number'])
    #     df_list = self.getSequenceFromCurrentTime()
    #     combined_df_sorted = self.sortDataframeList(df_list)
    #     new_df = self.addFeaturesToDataframe(combined_df_sorted)
    #     new_df_list = self.convertDataframeToList(new_df)

    #     return new_df_list