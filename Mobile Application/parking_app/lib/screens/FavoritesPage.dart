import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/controller/LoginController.dart';
import 'package:parking_app/handlers/LoginHandler.dart';
import 'package:parking_app/screens/SettingsPage.dart';
import 'package:parking_app/widgets/FavoritedParkingInfoWidget.dart';
import 'package:parking_app/widgets/LoginSelectorWidget.dart';

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _orangeColor = context.theme.primaryColor;
    final _lightOrangeColor = Color(0xFFFFBFA0);

    final settingsButton = IconButton(
      icon: Icon(Icons.settings),
      color: Colors.white,
      onPressed: () => Get.to(SettingsPage()),
      splashColor: Colors.black12,
      highlightColor: Colors.black12,
    );
    final logOutButton = IconButton(
      icon: Icon(Icons.logout),
      color: Colors.white,
      onPressed: () => _showAlertDialog(context),
      splashColor: Colors.black12,
      highlightColor: Colors.black12,
    );

    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (state) => Scaffold(
        appBar: AppBar(
          title: Text("Favorites",
              style: TextStyle(color: Colors.white, fontSize: 20)),
          actions: [
            state.isSignedIn ? logOutButton : Container(),
            settingsButton
          ],
        ),
        body: state.isSignedIn
            ? Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    FavoritedParkingInfo(
                      parkingName:
                          'BLK 270/271 ALBERT CENTRE BASEMENT CAR PARK',
                      parkingType: 'Basement Car Park',
                      currentAvailable: '245',
                      carParkID: 'HE45',
                      lat: 1,
                      lng: 30,
                      predictions: [235],
                    ),
                  ],
                ),
              )
            : LoginSelectorWidget(),
      ),
    );
  }

  Future<void> _showAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
