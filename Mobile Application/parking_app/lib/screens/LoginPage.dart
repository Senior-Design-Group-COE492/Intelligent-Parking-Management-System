import 'package:flutter/material.dart';
import 'package:parking_app/widgets/EmailLoginWidget.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: EmailLoginWidget(),
    );
  }
}
