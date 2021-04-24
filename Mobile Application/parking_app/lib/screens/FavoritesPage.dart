import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/controller/LoginController.dart';
import 'package:parking_app/handlers/LoginHandler.dart';
import 'package:parking_app/screens/SettingsPage.dart';
import 'package:parking_app/widgets/authentication_widgets/LoginSelectorWidget.dart';
import 'package:parking_app/widgets/favorites_widgets/FavoritesListWidget.dart';

class Favorites extends StatelessWidget {
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
        body: state.isSignedIn ? FavoritesList() : LoginSelectorWidget(),
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
