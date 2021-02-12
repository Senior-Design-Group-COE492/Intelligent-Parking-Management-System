import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_app/controller/MapsController.dart';

class FavoritedParkingInfo extends StatelessWidget {
  final String carParkID;
  final double lat;
  final double lng;
  final String parkingName;
  final String parkingType;
  final String currentAvailable;
  final List<int> predictions;
  const FavoritedParkingInfo({
    Key key,
    @required this.carParkID,
    @required this.lat,
    @required this.lng,
    @required this.parkingName,
    @required this.parkingType,
    @required this.currentAvailable,
    @required this.predictions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double widgetWidth =
        Get.width * 0.915; // 343/375 = 0.915 (width from design)
    final double widgetHeight = 202;
    final double headerTextWidth =
        Get.width * 0.717; // 269/375 = 0.915 (from design)

    final LatLng latLng = LatLng(lat, lng);

    final viewMapOnPressed = () async {
      DefaultTabController.of(context).animateTo(0);
      MapsController.to.showInfoWindow('HE45');
      final GoogleMapController controller =
          await MapsController.to.controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: latLng,
        zoom: 18,
      )));
    };

    final startNavigationOnPressed =
        () async => MapsController.to.startNavigation(lat, lng, carParkID);

    final buttonTextStyle = TextStyle(
        color: Theme.of(context).accentColor, fontWeight: FontWeight.w500);
    final TextStyle smallFontLight =
        TextStyle(fontSize: 12, fontWeight: FontWeight.w300);
    final TextStyle smallFontWithColor = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 12,
        fontWeight: FontWeight.bold);
    final predictedAvailableWidget =
        Text(predictions[0].toString() + ' spaces', style: smallFontWithColor);

    final topPadding16 = Padding(padding: EdgeInsets.only(top: 16));

    final buttonsRow = Container(
        // offsetting the default button padding to align everything
        transform: Matrix4.translationValues(-8, 0, 0),
        child: Row(
          children: [
            Container(
                child: TextButton(
              child: Text('VIEW IN MAP', style: buttonTextStyle),
              onPressed: viewMapOnPressed,
            )),
            Container(
                child: TextButton(
              child: Text('START NAVIGATION', style: buttonTextStyle),
              onPressed: startNavigationOnPressed,
            )),
          ],
        ));

    final Container header = Container(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              parkingName.toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            width: headerTextWidth,
          ),
          Expanded(
              child: PopupMenuButton(
            onSelected: (selected) {},
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Text('Working a lot harder'),
              )
            ],
          )),
        ],
      ),
    );

    final parkingTypeWidget = Text(parkingType, style: TextStyle(fontSize: 12));
    final currentAvailableWidget = Text(currentAvailable.toString() + ' spaces',
        style: smallFontWithColor);
    return Container(
      width: widgetWidth,
      height: widgetHeight,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          parkingTypeWidget,
          topPadding16,
          Text('Currently available parking spaces', style: smallFontLight),
          currentAvailableWidget,
          topPadding16,
          Text('Predicted available parking spaces in 30 minutes',
              style: smallFontLight),
          predictedAvailableWidget,
          buttonsRow,
        ],
      ),
    );
  }
}
