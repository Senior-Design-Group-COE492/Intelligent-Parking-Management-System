import 'package:firebase_auth/firebase_auth.dart';

class RegisterHandler {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<bool> register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('Email already in use.');
      }
    }
    return false;
  }
}
