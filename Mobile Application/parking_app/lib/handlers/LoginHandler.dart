import 'package:dio/dio.dart';
import 'package:parking_app/globals/Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginHandler {
  FirebaseAuth auth = FirebaseAuth.instance;

  final String email, password;

  LoginHandler(this.email, this.password);

  static Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: this.email, password: this.password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return false;
  }
}
