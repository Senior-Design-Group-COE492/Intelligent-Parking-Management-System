import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:parking_app/controller/MapsController.dart';
import 'package:parking_app/globals/MapsGlobals.dart';

class MarkerHandler {
  static Map parkingLots;
  final MapsController mapsController = Get.put(MapsController());

  static Future<void> getJsonFromFile() async {
    final parkingLotsString = await rootBundle
        .loadString("assets/carpark_info/mock/hdb-carpark-information.json");
    parkingLots = jsonDecode(parkingLotsString);
  }

  static Future<Marker> _makeMarker(
      double width,
      double height,
      int nAvailableParkingSpaces,
      LatLng latLng,
      String markerIdString,
      Function() handleMarkerTap) async {
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(
        MapsGlobals.makeMapMarkerSvg(nAvailableParkingSpaces), null);
    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));
    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final newMarkerBitmap =
        BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
    return Marker(
      markerId: MarkerId(markerIdString),
      icon: newMarkerBitmap,
      position: latLng,
      onTap: handleMarkerTap,
    );
  }

  static void addMarkersFromJson(BuildContext context) async {
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width = 40 * devicePixelRatio;
    double height = 47 * devicePixelRatio;
    // TODO: move the handleMarkerTap inside the loop
    // and add the parking ID to it
    final handleMarkerTap = () => MapsController.to.showInfoWindow('HE45');
    for (var i = 0; i < parkingLots.length; i++) {
      final String iString = i.toString();
      final int nAvailableParkingSpaces =
          int.parse(parkingLots[iString]['carpark_info'][0]['lots_available']);
      final double latitude = parkingLots[iString]['lat'];
      final double longitude = parkingLots[iString]['lng'];
      final LatLng latLng = LatLng(latitude, longitude);
      final newMarker = await _makeMarker(width, height,
          nAvailableParkingSpaces, latLng, iString, handleMarkerTap);
      MapsController.to.addMarkerToMap(newMarker);
    }
  }
}
