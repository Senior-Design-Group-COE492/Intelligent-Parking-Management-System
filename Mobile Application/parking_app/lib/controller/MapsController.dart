import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsController extends GetxController {
  // below link to docs explains how to make and use controllers
  // https://github.com/jonataslaw/getx/blob/master/documentation/en_US/state_management.md#simple-state-manager
  // use GetBuilder when actually using the controller
  // use MapsController.to.func() for functions
  Position currentLocation;
  Set markerSet = Set<Marker>();
  bool isHidden = false;
  bool isParkingInfo =
      false; // info window shown when true, textfield shown when false
  String parkingId = '';
  Completer<GoogleMapController> controller = Completer();
  static MapsController get to => Get.find();

  void setCurrentLocation(newCurrentLocation) {
    currentLocation = newCurrentLocation;
    update();
  }

  void setGoogleMapController(GoogleMapController newController) {
    controller.complete(newController);
    update();
  }

  void addMarkerToMap(Marker marker) async {
    markerSet.add(marker);
    update();
  }

  void toggleIsHidden() {
    isHidden = !isHidden;
    update();
  }

  void hideInfoWindow() {
    parkingId = '';
    isParkingInfo = false;
    update();
  }

  void showInfoWindow(String parkingId) {
    // updates parking id to show the appropriate information in the info window
    // also enables the infoWindow
    this.parkingId = parkingId;
    isParkingInfo = true;
    update();
  }
}
