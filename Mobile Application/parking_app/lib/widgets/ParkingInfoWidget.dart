import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/controller/MapsController.dart';
import 'package:parking_app/globals/Globals.dart';

class ParkingInfo extends StatelessWidget {
  // TODO: add constructor with parking ID
  final String distanceFromCurrent;
  final String routeTimeFromCurrent;
  final int currentAvailable;
  final String parkingName;
  final String parkingType;
  final List<int> predictions;
  final RxBool isExpanded = false.obs;

  ParkingInfo(
      {Key key,
      @required this.distanceFromCurrent,
      @required this.routeTimeFromCurrent,
      @required this.currentAvailable,
      @required this.predictions,
      @required this.parkingName,
      @required this.parkingType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double widgetWidth =
        Get.width * 0.915; // 343/375 = 0.915 (width from design)
    final double unexpandedHeight = 290;
    final double headerTextWidth =
        Get.width * 0.717; // 269/375 = 0.915 (from design)
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // calculates extra margin with status bar height
    final double marginWithStatusBar = statusBarHeight + 36;
    // subtracts the top margin and navigation bar height and a bit extra so
    // that the expanded widget doesn't go below the navigation bar
    final double expandedHeight = Get.height - marginWithStatusBar - 70 - 36;
    final double widthPadding = Get.width * 0.043; // 16/375 = 0.043
    final TextStyle smallFontLight =
        TextStyle(fontSize: 12, fontWeight: FontWeight.w300);
    final TextStyle smallFontWithColor = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 12,
        fontWeight: FontWeight.bold);

    final Container header = Container(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(top: 12),
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
            // EXpanded needed to prevent button from overflowing due to padding
            child: FloatingActionButton(
              // Can't use IconButton since ripple effect is messed up for it
              // so using FAB with no elevation instead
              hoverElevation: 0,
              disabledElevation: 0,
              highlightElevation: 0,
              focusElevation: 0,
              mini: true,
              elevation: 0,
              child: Icon(
                Icons.close,
                size: 35,
              ),
              onPressed: () => MapsController.to.hideInfoWindow(),
            ),
          ),
        ],
      ),
    );

    final parkingTypeWidget = Text(parkingType, style: TextStyle(fontSize: 12));

    final distanceFromCurrentWidget =
        Text(distanceFromCurrent, style: smallFontWithColor);

    final currentRouteTimeWidget =
        Text(routeTimeFromCurrent, style: smallFontWithColor);

    final currentAvailableWidget = Text(
      currentAvailable.toString() + ' spaces',
      style: smallFontWithColor,
    );

    final predictedAvailableWidget = Text(
      predictions[0].toString() + ' spaces',
      style: smallFontWithColor,
    );

    final footerWidget = Container(
      alignment: Alignment.center,
      child: Text(
        'Click for more detailed information and for route',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );

    return Listener(
      onPointerUp: (event) => isExpanded.toggle(),
      child: Align(
        alignment: Alignment.topCenter,
        child: Obx(
          () => AnimatedContainer(
            duration: Globals.EXPAND_ANIMATION_DURATION,
            padding: EdgeInsets.only(left: widthPadding, right: widthPadding),
            width: widgetWidth,
            height: isExpanded.value ? expandedHeight : unexpandedHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Color(0xE6FFFFFF),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 16,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            margin: EdgeInsets.only(top: marginWithStatusBar),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header,
                  parkingTypeWidget,
                  Padding(padding: EdgeInsets.only(top: 16)),
                  Text('Distance from current location', style: smallFontLight),
                  distanceFromCurrentWidget,
                  Padding(padding: EdgeInsets.only(top: 16)),
                  Text('Route time from current location',
                      style: smallFontLight),
                  currentRouteTimeWidget,
                  Padding(padding: EdgeInsets.only(top: 16)),
                  Text('Currently available parking spaces',
                      style: smallFontLight),
                  currentAvailableWidget,
                  Padding(padding: EdgeInsets.only(top: 16)),
                  Text('Predicted available parking spaces in 30 minutes',
                      style: smallFontLight),
                  predictedAvailableWidget,
                  Padding(padding: EdgeInsets.only(top: 20)),
                  // TODO: replace Text with a column for expansion
                  (isExpanded.value ? Text('text') : footerWidget),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
