import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/controller/LoginController.dart';
import 'package:parking_app/controller/WidgetsController.dart';
import 'package:parking_app/globals/Globals.dart';
import 'package:parking_app/handlers/MarkerHandler.dart';
import 'package:parking_app/widgets/search_widgets/CustomField.dart';
import 'package:parking_app/widgets/maps_widgets/MapsWidget.dart';
import 'package:parking_app/widgets/maps_widgets/ParkingInfoFromFutureWidget.dart';

class MapsPage extends StatelessWidget {
  final bool isHidden; // passed down from Navigation page

  MapsPage({Key? key, required this.isHidden}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final map = GestureDetector(
      child: Maps(),
      onDoubleTap: () => WidgetsController.to.toggleIsHidden(),
    );
    // TODO: Show ParkingInfo by Parking ID after constructor is made inside of
    // the ParkingInfo widget
    final topWidget = AnimatedContainer(
      duration: Globals.EXPAND_ANIMATION_DURATION + Duration(milliseconds: 100),
      height: isHidden ? 0 : Get.height,
      child: GetBuilder<WidgetsController>(
        init: WidgetsController(),
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
        child: GetBuilder<WidgetsController>(
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

    return Scaffold(
      body: GetBuilder<LoginController>(
          init: LoginController(),
          builder: (state) {
            //if (state.isSignedIn) MarkerHandler.startFavoritesStream(context);
            return Stack(
              children: stackChildren,
            );
          }),
    );
  }
}
