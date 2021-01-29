import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_app/globals/MapsGlobals.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class MapsController extends GetxController {
  // below link to docs explains how to make and use controllers
  // https://github.com/jonataslaw/getx/blob/master/documentation/en_US/state_management.md#simple-state-manager
  // use GetBuilder when actually using the controller
  // use MapsController.to.func() for functions
  Position currentLocation;
  Set markerSet = Set<Marker>();

  static MapsController get to => Get.find();

  void setCurrentLocation(newCurrentLocation) {
    currentLocation = newCurrentLocation;
    update();
  }

<<<<<<< HEAD
  void addMarkerToMap(double width, double height, int nAvailableParkingSpaces,
      LatLng latLng, String markerIdString) async {
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(
        MapsGlobals.makeMapMarkerSvg(nAvailableParkingSpaces), null);
    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));
    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final newMarkerBitmap =
        BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
    final newMarker = Marker(
        markerId: MarkerId(markerIdString),
        icon: newMarkerBitmap,
        position: latLng);
    markerSet.add(newMarker);
=======
  void addMarkerToMap(Marker marker) async {
    markerSet.add(marker);
>>>>>>> c72b00f995de72b8438411296e45a35df30ca68f
    update();
  }
}
