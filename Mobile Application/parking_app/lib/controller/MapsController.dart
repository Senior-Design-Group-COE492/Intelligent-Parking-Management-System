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

  void addMarkerToMap(Marker marker) async {
    markerSet.add(marker);
    update();
  }
}
