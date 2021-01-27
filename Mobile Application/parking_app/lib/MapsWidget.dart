import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking_app/controller/MapsController.dart';

class Maps extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapsState();
}

// the Mixin (and its override) is required to mantain the Maps after the user
// switches to another tab and then comes back to it
// the widget also needs to be stateful to use the mixin
class _MapsState extends State<Maps> with AutomaticKeepAliveClientMixin<Maps> {
  Completer<GoogleMapController> _controller = Completer();
  bool serviceEnabled;
  LocationPermission permission;
  final MapsController mapsController =  Get.put(MapsController());

  _MapsState() {
    _initializeGeolocator();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(1.308566, 103.857196),
          zoom: 13,
        ), // Initially at
        onMapCreated: (GoogleMapController controller) {
          if (!_controller.isCompleted) _controller.complete(controller);
        },
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        compassEnabled: false,
    ));
  }

  Future<void> _initializeGeolocator() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    final currentLocation = await Geolocator.getCurrentPosition();
    mapsController.setCurrentLocation(currentLocation);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom: 16,
    )));
  }
}
