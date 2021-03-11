import 'package:google_sign_in/google_sign_in.dart';
import 'package:parking_app/controller/LoginController.dart';
import 'package:parking_app/handlers/FirestoreHandler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginHandler {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      LoginController.to.setIsSignedIn(true);
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

  static Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw ('Google user is null!');
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken) as GoogleAuthCredential;
      // Once signed in, return the UserCredential
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      LoginController.to.setIsSignedIn(true);
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static bool isSignedIn() {
    return (auth.currentUser != null);
  }

  static Future<void> signOut() async {
    await auth.signOut();
    FirestoreHandler.signOutFromFirestore();
    LoginController.to.setIsSignedIn(false);
  }

  static bool isVerified() {
    // returns false if the user is not logged in or verified
    return auth.currentUser?.emailVerified ?? false;
  }

  static String? getCurrentUserID() {
    return auth.currentUser!.uid;
  }
}
