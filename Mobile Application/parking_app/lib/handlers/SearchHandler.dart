import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking_app/controller/MapsController.dart';
import 'package:parking_app/controller/TextFieldController.dart';
import 'package:parking_app/globals/Globals.dart';

class SearchHandler {
  static const apiKey = 'AIzaSyDBMJZInXD8H17mj712EHBPalwzIZ-k4oY';

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

  static Future<dynamic> searchParkings() async {
    final destinationLocation = MapsController.to.destinationLocation!;
    final filters = FieldController.to;
    final parkingTypes = _parkingTypeMapper(filters);
    final body = {
      'lat': destinationLocation.latitude,
      'lon': destinationLocation.longitude,
      'night_parking': filters.nightRadioValue.value == 0 ? 'NO' : 'YES',
      'type_of_parking_system': filters.parkingTypeRadioValue.value == 0
          ? 'COUPON PARKING'
          : 'ELECTRONIC PARKING',
      'car_park_type': parkingTypes,
    };
    print(body);
    final response = await Dio()
        .post(Globals.IP_ADDRESS + '/parking', queryParameters: body);
    return 0;
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
