import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/controller/MapsController.dart';
import 'package:parking_app/globals/Globals.dart';
import 'package:parking_app/widgets/CustomField.dart';
import 'package:parking_app/widgets/MapsWidget.dart';
import 'package:parking_app/widgets/ParkingInfoFromFutureWidget.dart';

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
            ? ParkingInfoFromFuture(parkingId: state.parkingId)
            : Container(
                child: CustomTextField(),
                height: 100,
                width: Get.width,
              ),
      ),
    );

    final loadingWidget = AnimatedContainer(
        duration:
            Globals.EXPAND_ANIMATION_DURATION + Duration(milliseconds: 100),
        padding: EdgeInsets.only(top: 125, left: 17, right: 16),
        height: isHidden ? 0 : 170,
        width: 100,
        child: GetBuilder<MapsController>(
          builder: (state) => state.isLoading
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(3)),
                  child: Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 35,
                      child: CircularProgressIndicator(strokeWidth: 2.5)),
                )
              : Container(),
        ));

    final List<Widget> stackChildren = [
      map,
      loadingWidget,
      topWidget,
    ];

    return Stack(
      children: stackChildren,
    );
  }
}
