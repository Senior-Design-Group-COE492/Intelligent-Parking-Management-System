import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:parking_app/controller/MapsController.dart';
import 'package:parking_app/controller/WidgetsController.dart';
import 'package:parking_app/globals/MapsGlobals.dart';
import 'package:parking_app/handlers/FirestoreHandler.dart';
import 'package:parking_app/handlers/LoginHandler.dart';

class MarkerHandler {
  static Map? parkingLots;
  static Stream<DocumentSnapshot>? favoritesStream;

  static Future<void> getJsonFromFile() async {
    final parkingLotsString = await rootBundle
        .loadString("assets/carpark_info/mock/hdb-carpark-information.json");
    parkingLots = jsonDecode(parkingLotsString);
    MapsController.to.setAllCarParks((parkingLots as Map));
  }

  static Future<Marker> _makeParkingMarker(
      double width,
      double height,
      int nAvailableParkingSpaces,
      LatLng latLng,
      String markerIdString,
      Function() handleMarkerTap) async {
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(
        MapsGlobals.makeMapMarkerSvg(nAvailableParkingSpaces), '0');
    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));
    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData bytes =
        (await (image.toByteData(format: ui.ImageByteFormat.png)))!;
    final newMarkerBitmap =
        BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
    return Marker(
      markerId: MarkerId(markerIdString),
      icon: newMarkerBitmap,
      position: latLng,
      onTap: handleMarkerTap,
    );
  }

  static Future<void> addDestinationMarker(
      double lat, double lng, BuildContext context) async {
    final marker = await makeDestinationMarker(lat, lng, context);
    MapsController.to.addMarkerToMap(marker);
  }

  static Future<Marker> makeDestinationMarker(
      double lat, double lng, BuildContext context) async {
    DrawableRoot svgDrawableRoot =
        await svg.fromSvgString(MapsGlobals.flagSvg, '1');
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width =
        24 * devicePixelRatio; // where 32 is your SVG's original width
    double height = 24 * devicePixelRatio; // same thing
    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));
    ui.Image image = await picture.toImage(width.toInt(), height.toInt());
    ByteData? bytes = await (image.toByteData(format: ui.ImageByteFormat.png));
    final markerBitmap =
        BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());

    final marker = Marker(
        markerId: MarkerId('destination'),
        icon: markerBitmap,
        position: LatLng(lat, lng));
    return marker;
  }

  static void addMarkersFromJson(BuildContext context) async {
    if (parkingLots == null) await getJsonFromFile();
    WidgetsController.to.setIsLoading(true);
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width = 40 * devicePixelRatio;
    double height = 47 * devicePixelRatio;
    final Set markerSet = Set<Marker>();
    int counter = 0;
    parkingLots!.forEach((carParkID, carParkInformation) async {
      final int nAvailableParkingSpaces =
          int.parse(carParkInformation['lots_available']);
      final double latitude = carParkInformation['lat'];
      final double longitude = carParkInformation['lng'];
      final LatLng latLng = LatLng(latitude, longitude);

      final handleMarkerTap = () async {
        WidgetsController.to.showInfoWindow(carParkID);
        MapsController.to.moveMapCamera(latitude, longitude, 18);
      };

      final newMarker = await _makeParkingMarker(width, height,
          nAvailableParkingSpaces, latLng, carParkID, handleMarkerTap);
      markerSet.add(newMarker);

      if (++counter == 716)
        MapsController.to.setMarkerSet(markerSet as Set<Marker>);

      // for performance, state is only updated after all the markers are added
    });

    MapsController.to.setDisplayedCarParks(parkingLots!);
    WidgetsController.to.setIsLoading(false);
  }

  static void addMarkersFromFavorites(
      BuildContext context, List<dynamic> favorites) async {
    if (parkingLots == null) await getJsonFromFile();
    WidgetsController.to.setIsLoading(true);
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width = 40 * devicePixelRatio;
    double height = 47 * devicePixelRatio;
    final Set<Marker> markerSet = Set<Marker>();
    int counter = favorites.length;

    favorites.forEach((carParkID) async {
      print(carParkID);
      final carParkInformation = parkingLots![carParkID];
      final int nAvailableParkingSpaces =
          int.parse(carParkInformation['lots_available']);
      final double latitude = carParkInformation['lat'];
      final double longitude = carParkInformation['lng'];
      final LatLng latLng = LatLng(latitude, longitude);

      final handleMarkerTap = () async {
        WidgetsController.to.showInfoWindow(carParkID);
        MapsController.to.moveMapCamera(latitude, longitude, 18);
      };

      final newMarker = await _makeParkingMarker(width, height,
          nAvailableParkingSpaces, latLng, carParkID, handleMarkerTap);
      markerSet.add(newMarker);
      if (--counter == 0) MapsController.to.setMarkerSet(markerSet);
      // for performance, state is only updated after all the markers are added
    });

    MapsController.to.setDisplayedCarParks(parkingLots!);
    WidgetsController.to.setIsLoading(false);
  }

  static void startFavoritesStream(BuildContext context) async {
    if (favoritesStream == null) {
      favoritesStream = await FirestoreHandler.getUserInformationStream(
          LoginHandler.getCurrentUserID()!);
      favoritesStream!.listen((favoritesDoc) {
        addMarkersFromFavorites(context, favoritesDoc.data()?['favorites']);
      });
    }
  }

  static Future<void> setMarkersFromFilterAndDestination(BuildContext context,
      Map<String, dynamic> filteredParkings, Marker destinationMarker) async {
    if (parkingLots == null) await getJsonFromFile();
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width = 40 * devicePixelRatio;
    double height = 47 * devicePixelRatio;
    final Set<Marker> markerSet = Set<Marker>();
    int counter = filteredParkings.length;
    if (filteredParkings.length == 0) {
      markerSet.add(destinationMarker);
      MapsController.to.setMarkerSet(markerSet);
      return;
    }
    filteredParkings.forEach((carParkID, carParkInformation) async {
      final int nAvailableParkingSpaces =
          int.parse(carParkInformation['lots_available']);
      final double latitude = carParkInformation['lat'];
      final double longitude = carParkInformation['lng'];
      final LatLng latLng = LatLng(latitude, longitude);

      final handleMarkerTap = () async {
        WidgetsController.to.showInfoWindow(carParkID);
        MapsController.to.moveMapCamera(latitude, longitude, 18);
      };

      final newMarker = await _makeParkingMarker(width, height,
          nAvailableParkingSpaces, latLng, carParkID, handleMarkerTap);
      markerSet.add(newMarker);

      if (--counter == 0) {
        markerSet.add(destinationMarker);
        MapsController.to.setMarkerSet(markerSet);
      }

      // for performance, state is only updated after all the markers are added
    });

    MapsController.to.setDisplayedCarParks(filteredParkings);
  }
}
