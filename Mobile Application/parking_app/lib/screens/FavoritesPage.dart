import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/controller/LoginController.dart';
import 'package:parking_app/handlers/LoginHandler.dart';
import 'package:parking_app/widgets/FavoritedParkingInfoWidget.dart';
import 'package:parking_app/widgets/LoginSelectorWidget.dart';

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites",
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      // TODO: change the temperorary TextButton to the favorites widget
      // also make signedIn state global?
      body: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (state) => state.isSignedIn
            ? TextButton(
                child: Text(LoginHandler.auth.currentUser.email),
                onPressed: () {
                  LoginHandler.signOut();
                })
            : FavoritedParkingInfo(
                parkingName: 'BLK 270/271 ALBERT CENTRE BASEMENT CAR PARK',
                parkingType: 'Basement Car Park',
                currentAvailable: '245',
                carParkID: 'HE45',
                lat: 1,
                lng: 30,
                predictions: [235],
              ),
      ),
    );
  }
}
