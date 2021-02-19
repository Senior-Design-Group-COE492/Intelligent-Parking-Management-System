import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _orangeColor = context.theme.primaryColor;
    final _lightOrangeColor = Color(0xFFFFBFA0);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please verify your email then login again.',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            FlatButton(
              onPressed: () => Get.back(),
              color: _orangeColor,
              disabledColor: _lightOrangeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              height: 52,
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
