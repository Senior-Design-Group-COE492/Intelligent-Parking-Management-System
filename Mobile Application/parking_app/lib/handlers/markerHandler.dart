import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

import 'package:parking_app/controller/MapsController.dart';

class MarkerHandler {
  static Map parkingLots;
  final MapsController mapsController = Get.put(MapsController());

  static Future<void> getJsonFromFile() async {
    final parkingLotsString = await rootBundle
        .loadString("assets/carpark_info/mock/hdb-carpark-information.json");
    parkingLots = jsonDecode(parkingLotsString);
  }

  static void addMarkersFromJson(BuildContext context) async {
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width = 40 * devicePixelRatio;
    double height = 47 * devicePixelRatio;
    for (var i = 0; i < parkingLots.length; i++) {
      final String iString = i.toString();
      final int nAvailableParkingSpaces =
          int.parse(parkingLots[iString]['carpark_info'][0]['lots_available']);
      final double latitude = parkingLots[iString]['lat'];
      final double longitude = parkingLots[iString]['lng'];
      final LatLng latLng = LatLng(latitude, longitude);
      MapsController.to
          .addMarkerToMap(width, height, nAvailableParkingSpaces, latLng, iString);
    }
  }
}
