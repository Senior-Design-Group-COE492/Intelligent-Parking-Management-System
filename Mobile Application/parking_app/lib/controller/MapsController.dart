import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';

class MapsController extends GetxController {
  // below link to docs explains how to make and use controllers
  // https://github.com/jonataslaw/getx/blob/master/documentation/en_US/state_management.md#simple-state-manager
  // use GetBuilder when actually using the controller
  // use MapsController.to.func() for functions
  Position? currentLocation;
  LatLng? destinationLocation;
  Set<Marker> markerSet = Set<Marker>();
  Completer<GoogleMapController> controller = Completer();
  Map? allCarParks;
  Map? displayedCarParks;

  final availableMapsFuture = MapLauncher.installedMaps;
  static MapsController get to => Get.find();

  void setCurrentLocation(Position newCurrentLocation) {
    currentLocation = newCurrentLocation;
    update();
  }

  void setDestinationLocation(double lat, double lng) {
    destinationLocation = LatLng(lat, lng);
    update();
  }

  void setDisplayedCarParks(Map newDisplayedCarParks) {
    displayedCarParks = newDisplayedCarParks;
    update();
  }

  void setAllCarParks(Map newAllCarParks) {
    allCarParks = newAllCarParks;
    update();
  }

  void setGoogleMapController(GoogleMapController newController) {
    if (!controller.isCompleted) {
      controller.complete(newController);
      update();
    }
  }

  void addMarkerToMap(Marker marker) {
    // removes the previous marker if their is one with the same ID
    markerSet.remove(marker);
    markerSet.add(marker);
    update();
  }

  void setMarkerSet(Set<Marker> newMarkerSet) {
    markerSet = newMarkerSet;
    update();
  }

  void startNavigation(double lat, double lng, String title) async {
    final availableMaps = await availableMapsFuture;
    await availableMaps.first.showMarker(
      coords: Coords(lat, lng),
      title: title,
    );
  }

  void moveMapCamera(double lat, double lng, double zoom) async {
    final GoogleMapController googleMapController = await controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, lng),
      zoom: zoom,
    )));
  }
}
