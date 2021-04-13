import 'dart:async';

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

class MarkerHandler {
  static Map? parkingLots;

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
    MapsController.to.addMarkerToMap(marker);
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
}
