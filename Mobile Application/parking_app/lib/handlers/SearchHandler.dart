import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking_app/controller/MapsController.dart';
import 'package:parking_app/controller/TextFieldController.dart';
import 'package:parking_app/globals/Globals.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchHandler {
  static final apiKey = env['GOOGLE_MAPS_API_KEY'];

  static Future<Response<dynamic>> _requestMaker(String place, String region) {
    final response = Dio().get(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?',
        queryParameters: {
          'key': apiKey,
          'query': place,
          'region': region,
        });
    return response;
  }

  static Future<List<dynamic>> searchPlace(String place, String region) async {
    final response = await _requestMaker(place, region);
    return response.data['results'];
  }

  static List<String> generateAddresses(List<dynamic> places) {
    final List<String> combinedAddress = [];
    for (final place in places) {
      if (place['formatted_address'] == null)
        combinedAddress.add(place['name']);
      else
        combinedAddress.add(place['name'] + ', ' + place['formatted_address']);
    }
    return combinedAddress;
  }

  static Future<Map<String, dynamic>> getRouteTime(Position currentLocation,
      double destinationLat, double destinationLng) async {
    final response = await Dio().get(
        'https://maps.googleapis.com/maps/api/distancematrix/json?',
        queryParameters: {
          'key': apiKey,
          'units': 'metric',
          'origins': '${currentLocation.latitude},${currentLocation.longitude}',
          'destinations': '$destinationLat,$destinationLng'
        });
    return response.data['rows'][0]['elements'][0];
  }

  static Future<Map<String, dynamic>> searchParkings() async {
    final destinationLocation = MapsController.to.destinationLocation!;
    final filters = FieldController.to;

    final typeOfParkingSystem = filters.parkingTypeRadioValue.value == 0
        ? null
        : filters.parkingTypeRadioValue.value == 1
            ? 'ELECTRONIC PARKING'
            : 'COUPON PARKING';
    final parkingTypes = _parkingTypeMapper(filters);
    final nightParking = filters.nightRadioValue.value == 1 ? null : 'YES';

    final Map<String, dynamic> body = {
      'lat': destinationLocation.latitude,
      'lon': destinationLocation.longitude,
      'distance': filters.distanceSliderValue.value,
    };

    if (typeOfParkingSystem != null)
      body['type_of_parking_system'] = typeOfParkingSystem;
    if (nightParking != null) body['night_parking'] = nightParking;
    if (parkingTypes.length > 0) body['car_park_type'] = parkingTypes;
    print(body);

    final response = await Dio().post(
      'http://' + Globals.IP_ADDRESS + '/filter',
      data: body,
    );
    final Map<String, dynamic> filteredParkings = jsonDecode(response.data);

    return filteredParkings;
  }

  static List<String> _parkingTypeMapper(FieldController filters) {
    final List<String> parkingTypes = [];

    if (filters.isSurface.value!) parkingTypes.add('SURFACE CAR PARK');
    if (filters.isMultiStorey.value!) parkingTypes.add('MULTI-STOREY CAR PARK');
    if (filters.isBasement.value!) parkingTypes.add('BASEMENT CAR PARK');
    if (filters.isCovered.value!) parkingTypes.add('COVERED CAR PARK');
    if (filters.isMechanised.value!)
      parkingTypes.add('MECHANISED AND SURFACE CAR PARK');

    return parkingTypes;
  }
}
