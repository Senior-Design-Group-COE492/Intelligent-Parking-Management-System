import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/controller/MapsController.dart';
import 'package:parking_app/controller/WidgetsController.dart';
import 'package:parking_app/globals/Globals.dart';
import 'package:parking_app/handlers/FirestoreHandler.dart';
import 'package:parking_app/screens/FavoritesPage.dart';
import 'package:parking_app/screens/MapsPage.dart';

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
      GetBuilder<WidgetsController>(
        init: WidgetsController(),
        builder: (state) => MapsPage(isHidden: state.isHidden),
      ),
      Favorites(),
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
          GetBuilder<WidgetsController>(
            init: WidgetsController(),
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
                  // need to re-assign stream because it gets stuck on waiting
                  // if the re-assigning does not happen
                  onTap: (tabIndex) =>
                      FirestoreHandler.updateCurrentInformationStream(),
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
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
    return tabsWidget;
  }
}
