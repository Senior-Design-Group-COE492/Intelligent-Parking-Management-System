import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/controller/MapsController.dart';
import 'package:parking_app/controller/WidgetsController.dart';
import 'package:parking_app/globals/Globals.dart';
import 'package:parking_app/handlers/FirestoreHandler.dart';
import 'package:parking_app/handlers/LoginHandler.dart';
import 'package:parking_app/handlers/NotificationHandler.dart';
import 'package:parking_app/widgets/maps_widgets/PredictionsBarChart.dart';

class ParkingInfo extends StatelessWidget {
  final String? carParkID;
  final String? distanceFromCurrent;
  final String? routeTimeFromCurrent;
  final Stream<DocumentSnapshot>? currentAvailableStream;
  final String? parkingName;
  final String? parkingType;
  final double? gantryHeight;
  final String? freeParking;
  final String? shortTermParking;
  final String? nightParking;
  final String? parkingSystem;
  final Stream<DocumentSnapshot>? predictedAvailableStream;
  final bool isLoading;
  final double? lat;
  final double? lng;
  final RxBool isFavorited = false.obs;
  RxBool isParkingInfoExpanded = false.obs;

  void startNotifications(String pID) async {
    Stream<DocumentSnapshot> stream =
        FirestoreHandler.updatePredictedInformationStream();
    stream.listen((event) {
      Map<String, dynamic>? predAval = event.data();
      double predAvail = predAval!['predictions'][pID][0];
      int avail = predAvail.toInt();
      print('Predicted: $avail');

      if (avail < 10) {
        NotificationService().showNotification(
            'Parking Lot predicted availability is low ($avail spaces left). Click to switch parking area.');
      }
    });
  }

  ParkingInfo({
    Key? key,
    required this.distanceFromCurrent,
    required this.routeTimeFromCurrent,
    required this.currentAvailableStream,
    required this.predictedAvailableStream,
    required this.parkingName,
    required this.parkingType,
    required this.lat,
    required this.lng,
    required this.gantryHeight,
    required this.freeParking,
    required this.shortTermParking,
    required this.nightParking,
    required this.parkingSystem,
    required this.carParkID,
    this.isLoading = false,
  }) : super(key: key);

  // constructor to show CircularProgress
  // NOTE: initializing the other variables doesn't matter as CircularProgress
  // would always be shown
  ParkingInfo.isLoading({
    Key? key,
    this.distanceFromCurrent,
    this.routeTimeFromCurrent,
    this.currentAvailableStream,
    this.predictedAvailableStream,
    this.parkingName,
    this.parkingType,
    this.lat,
    this.lng,
    this.gantryHeight,
    this.freeParking,
    this.shortTermParking,
    this.nightParking,
    this.carParkID,
    this.parkingSystem,
  }) : isLoading = true;

  @override
  Widget build(BuildContext context) {
    final double widgetWidth =
        Get.width * 0.915; // 343/375 = 0.915 (width from design)
    final double buttonHeight = 45;
    final double unexpandedHeight = 292 + buttonHeight + 12;
    final double headerTextWidth =
        Get.width * 0.717; // 269/375 = 0.915 (from design)
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // calculates extra margin with status bar height
    final double marginWithStatusBar = statusBarHeight + 16;
    // subtracts the top margin and navigation bar height and a bit extra so
    // that the expanded widget doesn't go below the navigation bar
    final double expandedHeight = Get.height - marginWithStatusBar - 70 - 16;
    final double widthPadding = Get.width * 0.043; // 16/375 = 0.043
    final double navigationButtonWidth = Get.width * 0.66; // 247/375 = 0.66

    if (isLoading)
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.only(left: widthPadding, right: widthPadding),
          width: widgetWidth,
          height: unexpandedHeight,
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
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(strokeWidth: 2.5)),
          ),
        ),
      );

    final TextStyle smallFontLight =
        TextStyle(fontSize: 12, fontWeight: FontWeight.w300);
    final TextStyle smallFontWithColor = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 12,
        fontWeight: FontWeight.bold);
    final topPadding16 = Padding(padding: EdgeInsets.only(top: 16));
    final topPadding12 = Padding(padding: EdgeInsets.only(top: 12));

    final Container header = Container(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              parkingName!.toUpperCase(),
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
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Icon(
                Icons.close,
                size: 35,
              ),
              onPressed: () => WidgetsController.to.hideInfoWindow(),
            ),
          ),
        ],
      ),
    );

    final parkingTypeWidget =
        Text(parkingType!, style: TextStyle(fontSize: 12));

    final distanceFromCurrentWidget =
        Text(distanceFromCurrent!, style: smallFontWithColor);

    final currentRouteTimeWidget =
        Text(routeTimeFromCurrent!, style: smallFontWithColor);

    final loadingIndicator = Align(
      alignment: Alignment.centerLeft,
      child: Container(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(context.theme.primaryColor),
        ),
        height: 15,
        width: 15,
      ),
    );

    final currentAvailableWidget = StreamBuilder(
        stream: currentAvailableStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return Text('Something went wrong');
          if (snapshot.connectionState == ConnectionState.waiting)
            return loadingIndicator;

          return Text(
              snapshot.data?.data()?['current_availability'][carParkID]
                      ['lots_available'] +
                  ' spaces',
              style: smallFontWithColor);
        });

    final predictedAvailableWidget = StreamBuilder(
        stream: predictedAvailableStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return Text('Something went wrong');
          if (snapshot.connectionState == ConnectionState.waiting)
            return loadingIndicator;

          String? thirtyMinutePrediction = snapshot.data
              ?.data()?['predictions'][carParkID][1]
              .toStringAsFixed(0);
          return Text(thirtyMinutePrediction! + ' spaces',
              style: smallFontWithColor);
        });

    final predictionsBarChart = StreamBuilder(
        stream: FirestoreHandler.updatePredictedInformationStream(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return Text('Something went wrong');
          if (snapshot.connectionState == ConnectionState.waiting)
            return loadingIndicator;

          List<double> predictions =
              snapshot.data?.data()?['predictions'][carParkID].cast<double>();
          return PredictionsBarChart(predictions);
        });

    final gantryHeightWidget = Text(gantryHeight!.toStringAsFixed(1) + ' m',
        style: smallFontWithColor);

    final freeParkingWidget = Text(freeParking!, style: smallFontWithColor);

    final shortTermParkingWidget =
        Text(shortTermParking!, style: smallFontWithColor);

    final nightParkingWidget = Text(nightParking!, style: smallFontWithColor);

    final parkingSystemWidget = Text(parkingSystem!, style: smallFontWithColor);

    final footerWidget = Container(
      alignment: Alignment.center,
      child: Text(
        'Click anywhere for more detailed information',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );

    final navigationButton = Container(
      height: buttonHeight,
      width: navigationButtonWidth,
      child: TextButton(
          child: Text(
            'START NAVIGATION',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              overlayColor: MaterialStateProperty.all<Color>(Colors.black12)),
          // TODO: Implement notifications to show the real-time availability
          // after clicking the button
          onPressed: () => {
                MapsController.to.startNavigation(lat!, lng!, parkingName!),
                startNotifications(carParkID!),
              }),
    );

    final favoritesButton = Obx(() => Expanded(
          child: FloatingActionButton(
            elevation: 0,
            hoverElevation: 0,
            disabledElevation: 0,
            highlightElevation: 0,
            focusElevation: 0,
            backgroundColor: Colors.transparent,
            child: Icon(
              isFavorited.value! ? Icons.star : Icons.star_outline,
              size: 30,
              color: Colors.grey[850],
            ),
            onPressed: () {
              if (LoginHandler.isSignedIn()) {
                isFavorited.toggle();
                if (isFavorited.value!)
                  FirestoreHandler.addFavorite(carParkID!);
                else
                  FirestoreHandler.removeFavorite(carParkID!);
              } else {
                Get.snackbar('Login required',
                    'Please login using the Favorites page first!',
                    duration: Duration(seconds: 3),
                    snackPosition: SnackPosition.BOTTOM,
                    onTap: (snackBar) =>
                        DefaultTabController.of(context)!.animateTo(1),
                    margin: EdgeInsets.only(
                        bottom: 86, left: widthPadding, right: widthPadding),
                    animationDuration: Duration(milliseconds: 250),
                    backgroundColor: Colors.grey[50]!.withOpacity(0.7));
              }
            },
          ),
        ));

    final buttonsRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [navigationButton, favoritesButton],
    );

    final expandedWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text('Predicted availability (may not be accurate)',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
        ),
        topPadding12,
        predictionsBarChart,
        Padding(padding: EdgeInsets.only(top: 8)),
        Text('Gantry height', style: smallFontLight),
        gantryHeightWidget,
        topPadding16,
        Text('Free parking', style: smallFontLight),
        freeParkingWidget,
        topPadding16,
        Text('Short term parking', style: smallFontLight),
        shortTermParkingWidget,
        topPadding16,
        Text('Night parking', style: smallFontLight),
        nightParkingWidget,
        topPadding16,
        Text('Parking system type', style: smallFontLight),
        parkingSystemWidget,
        topPadding16,
        buttonsRow,
        topPadding16,
      ],
    );

    return GestureDetector(
      onTap: () => isParkingInfoExpanded.toggle(),
      child: Align(
        alignment: Alignment.topCenter,
        child: Obx(
          () => AnimatedContainer(
            duration: Globals.EXPAND_ANIMATION_DURATION,
            padding: EdgeInsets.only(left: widthPadding, right: widthPadding),
            width: widgetWidth,
            height: isParkingInfoExpanded.value!
                ? expandedHeight
                : unexpandedHeight,
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
                  topPadding16,
                  Text('Distance from current location', style: smallFontLight),
                  distanceFromCurrentWidget,
                  topPadding16,
                  Text('Route time from current location',
                      style: smallFontLight),
                  currentRouteTimeWidget,
                  topPadding16,
                  Text('Currently available parking spaces',
                      style: smallFontLight),
                  currentAvailableWidget,
                  topPadding16,
                  Text('Predicted available parking spaces in 30 minutes',
                      style: smallFontLight),
                  predictedAvailableWidget,
                  topPadding12,
                  (isParkingInfoExpanded.value! ? Container() : buttonsRow),
                  Padding(padding: EdgeInsets.only(top: 4)),
                  (isParkingInfoExpanded.value!
                      ? expandedWidget
                      : footerWidget),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
