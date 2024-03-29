import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:parking_app/handlers/LoginHandler.dart';
import 'package:parking_app/screens/LoginPage.dart';
import 'package:parking_app/screens/RegisterPage.dart';

class LoginSelectorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final buttonWidth = Get.width * 0.85;
    final double buttonHeight = 60;
    final Row emailLoginRow = Row(
      children: [
        Icon(Icons.email, color: Colors.black),
        Padding(padding: EdgeInsets.only(left: 22)),
        Text('Sign in with Email',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black))
      ],
    );
    final Row googleLoginRow = Row(
      children: [
        // Note: these were following Google's mandatory guidelines and
        // cannot be changed
        SvgPicture.asset('assets/icons/googleLogo.svg', height: 24, width: 24),
        Padding(padding: EdgeInsets.only(left: 24)),
        Text('Sign in with Google',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black))
      ],
    );

    final ButtonStyle buttonStyle = ButtonStyle(
      elevation: MaterialStateProperty.resolveWith<double>(
          (states) => states.contains(MaterialState.pressed) ? 8 : 5),
      overlayColor: MaterialStateProperty.all<Color>(Colors.black12),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    );

    return Container(
      alignment: Alignment.center,
      child: Container(
        width: buttonWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign in with one of the options below to see your favorites',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            Padding(padding: EdgeInsets.only(bottom: Get.height * 0.15)),
            Container(
              height: buttonHeight,
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: () => Get.to(LoginPage()),
                child: emailLoginRow,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 16)),
            Container(
              height: buttonHeight,
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: () => LoginHandler.signInWithGoogle(),
                child: googleLoginRow,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: Get.height * 0.15)),
            TextButton(
              onPressed: () => {Get.to(RegisterPage())},
              child: Text(
                "Don't have an account? Click here to sign up!",
                style: TextStyle(
                    color: Colors.black, decoration: TextDecoration.underline),
              ),
            ),
            // bottom padding of 70 needed to offset navigation bar and
            // to properly center widget
            Padding(padding: EdgeInsets.only(bottom: 70)),
          ],
        ),
      ),
    );
  }
}
