import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/widgets/CustomField.dart';
import 'package:parking_app/widgets/MapsWidget.dart';
import 'package:parking_app/widgets/ParkingInfoWidget.dart';

class Navigation extends StatelessWidget {
  RxBool isHidden = true.obs;

  @override
  Widget build(BuildContext context) {
    final double navigationBarHeight = 70;

    final Widget mapIcon = Container(
      child: Icon(Icons.map_outlined, size: 30),
      width: Get.width * 0.30,
    );
    final Widget favoriteIcon = Container(
      child: Icon(Icons.star_border, size: 30),
      width: Get.width * 0.30,
    );

    final tabsChildrenList = [
      // TODO: add Map and Favorites Screens in this list
      GestureDetector(child: Maps(), onDoubleTap: isHidden.toggle),
      ParkingInfo(
        currentAvailable: 245,
        distanceFromCurrent: '1.1 km',
        routeTimeFromCurrent: '22 minutes',
        predictions: [179],
        parkingName: 'BLK 270/271 ALBERT CENTRE BASEMENT CAR PARK',
        parkingType: 'Basement Car Park',
      ),
    ];

    final tabsWidget = DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(children: [
          // Stack will be needed to put the Map widget "behind" everything else
          Container(
            // main container
            alignment: Alignment.center,
            child: TabBarView(
              // physics needed since tabbarview prevents users from moving map
              physics: NeverScrollableScrollPhysics(),
              children: tabsChildrenList,
            ),
          ),
          Obx(
            () => AnimatedContainer(
              // TabBar container
              curve: Curves.linearToEaseOut,
              duration: Duration(milliseconds: 500),
              height: isHidden.value ? navigationBarHeight : 0,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 24,
                    offset: Offset(-12, 0),
                  ),
                ],
              ),
              // margin offsets the tab bar to the bottom of the screen
              margin: EdgeInsets.only(
                  top: Get.height - (isHidden.value ? navigationBarHeight : 0)),
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black54,
                    indicator: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: context.theme.primaryColor,
                          width: 3,
                        ),
                      ),
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(
                        icon: mapIcon,
                        text: 'Map',
                      ),
                      Tab(
                        icon: favoriteIcon,
                        text: 'Favorites',
                      ),
                    ]),
              ),
            ),
          ),
        ]),
      ),
    );
    return tabsWidget;
  }
}
