import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

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
}
