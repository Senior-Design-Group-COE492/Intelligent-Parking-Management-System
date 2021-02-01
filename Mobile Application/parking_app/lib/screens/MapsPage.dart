import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/controller/MapsController.dart';
import 'package:parking_app/globals/Globals.dart';
import 'package:parking_app/widgets/CustomField.dart';
import 'package:parking_app/widgets/MapsWidget.dart';
import 'package:parking_app/widgets/ParkingInfoWidget.dart';

class MapsPage extends StatelessWidget {
  final bool isHidden; // passed down from Navigation page

  const MapsPage({Key key, @required this.isHidden}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final map = GestureDetector(
      child: Maps(),
      onDoubleTap: () => MapsController.to.toggleIsHidden(),
    );
    // TODO: Show ParkingInfo by Parking ID after constructor is made inside of
    // the ParkingInfo widget
    final topWidget = AnimatedContainer(
      duration: Globals.EXPAND_ANIMATION_DURATION + Duration(milliseconds: 100),
      height: isHidden ? 0 : Get.height,
      child: GetBuilder<MapsController>(
        init: MapsController(),
        builder: (state) => state.isParkingInfo
            ? ParkingInfo(
                currentAvailable: 245,
                distanceFromCurrent: '1.1 km',
                routeTimeFromCurrent: '22 minutes',
                predictions: [179],
                parkingName: 'BLK 270/271 ALBERT CENTRE BASEMENT CAR PARK',
                parkingType: 'Basement Car Park',
              )
            : Container(
                child: CustomTextField(), height: 100, width: Get.width),
      ),
    );

    final List<Widget> stackChildren = [
      map,
      topWidget,
    ];

    return Stack(
      children: stackChildren,
    );
  }
}
