import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking_app/screens/Navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          throw ('Snapshot has an error!!');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          FirebaseAuth.instance.sendSignInLinkToEmail(
              email: 'saif899056@gmail.com',
              actionCodeSettings: ActionCodeSettings(
                url: '', // TODO: add dynamic link url here
              ));
          return Navigation();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
