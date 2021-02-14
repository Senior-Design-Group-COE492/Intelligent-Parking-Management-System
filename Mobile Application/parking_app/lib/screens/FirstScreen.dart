import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/screens/RegisterPage.dart';
import 'package:parking_app/screens/LoginPage.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          children: [
            FlatButton(
              onPressed: () => Get.to(RegisterPage()),
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            FlatButton(
              onPressed: () => Get.to(LoginPage()),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
