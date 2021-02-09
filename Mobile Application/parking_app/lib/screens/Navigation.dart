import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/controller/MapsController.dart';
import 'package:parking_app/globals/Globals.dart';
import 'package:parking_app/screens/FavoritesPage.dart';
import 'package:parking_app/screens/MapsPage.dart';
import 'package:parking_app/widgets/CustomField.dart';
import 'package:parking_app/widgets/ParkingInfoWidget.dart';

class Navigation extends StatelessWidget {
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
      GetBuilder<MapsController>(
        init: MapsController(),
        builder: (state) => MapsPage(isHidden: state.isHidden),
      ),
      Favorites(),
      // ParkingInfo(
      //   currentAvailable: 245,
      //   distanceFromCurrent: '1.1 km',
      //   routeTimeFromCurrent: '22 minutes',
      //   predictions: [179],
      //   parkingName: 'BLK 270/271 ALBERT CENTRE BASEMENT CAR PARK',
      //   parkingType: 'Basement Car Park',
      //   gantryHeight: 4.5,
      //   freeParking:
      //       'All day on Sunday and public holidays, and Friday between 7AM - 10:30PM',
      //   shortTermParking: 'Available for the whole day',
      //   nightParking: 'Yes',
      //   parkingSystem: 'Electronic',
      //   lat: 1.01,
      //   lng: 30,
      // ),
      // CustomTextField(),
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
          GetBuilder<MapsController>(
            init: MapsController(),
            builder: (state) => AnimatedContainer(
              // TabBar container
              curve: Curves.linearToEaseOut,
              duration: Globals.MAPS_ANIMATION_DURATION,
              height: state.isHidden ? 0 : navigationBarHeight,
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
                  top: Get.height - (state.isHidden ? 0 : navigationBarHeight)),
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
