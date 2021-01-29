import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  Color initialColor = Color(0xFFFF8E71);

  void changeColor(Color color) {
    initialColor = color;
  }
}

class SettingsPage extends StatelessWidget {
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings Page"),
      ),
      body: Center(
        child: Column(
          children: [
            ListView(
              padding: EdgeInsets.all(10.0),
              children: <Widget>[],
            )
          ],
        ),
      ),
    );
  }
}
