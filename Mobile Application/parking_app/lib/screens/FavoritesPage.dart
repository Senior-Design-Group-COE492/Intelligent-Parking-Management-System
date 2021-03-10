import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/controller/LoginController.dart';
import 'package:parking_app/handlers/FirestoreHandler.dart';
import 'package:parking_app/handlers/LoginHandler.dart';
import 'package:parking_app/screens/SettingsPage.dart';
import 'package:parking_app/widgets/favorites_widgets/FavoritedParkingInfoWidget.dart';
import 'package:parking_app/widgets/authentication_widgets/LoginSelectorWidget.dart';

class Favorites extends StatelessWidget {
  Favorites() {
    if (LoginHandler.isSignedIn())
      FirestoreHandler.getUserInformation(LoginHandler.getCurrentUserID()!);
  }

  @override
  Widget build(BuildContext context) {
    final settingsButton = IconButton(
      icon: Icon(Icons.settings, color: Colors.white),
      onPressed: () => Get.to(SettingsPage()),
      splashColor: Colors.black12,
      highlightColor: Colors.black12,
    );
    final logOutButton = IconButton(
      icon: Icon(Icons.logout, color: Colors.white),
      onPressed: () => _showAlertDialog(context),
      splashColor: Colors.black12,
      highlightColor: Colors.black12,
    );

    final parkingWidget = FavoritedParkingInfo(
      parkingName: 'BLK 270/271 ALBERT CENTRE BASEMENT CAR PARK',
      parkingType: 'Basement Car Park',
      currentAvailable: '245',
      carParkID: 'HE45',
      lat: 1,
      lng: 30,
      predictions: [235],
    );

    var widgetList = <Widget>[
      parkingWidget,
      parkingWidget,
      parkingWidget,
      parkingWidget,
      parkingWidget,
    ].obs;

    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (state) => Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text("Favorites",
                style: TextStyle(fontSize: 20, color: Colors.white)),
            actions: [
              state.isSignedIn ? logOutButton : Container(),
              settingsButton
            ],
          ),
        ],
        body: state.isSignedIn
            ? Obx(
                () => Container(
                  padding: EdgeInsets.only(left: 15, top: 0),
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 16),
                    shrinkWrap: true,
                    itemCount: widgetList.length,
                    itemBuilder: (context, index) {
                      final double padding =
                          index == widgetList.length - 1 ? 90 : 10;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: widgetList[index]),
                              IconButton(
                                icon: Icon(Icons.delete_forever),
                                onPressed: () => {
                                  widgetList.removeAt(index),
                                  print(index),
                                  print(widgetList.length)
                                },
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: padding),
                          )
                        ],
                      );
                    },
                  ),
                ),
              )
            : LoginSelectorWidget(),
      )),
    );
  }

  Future<void> _showAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out of your account?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: Text('Log Out'),
              onPressed: () {
                LoginHandler.signOut();
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
