import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parking_app/screens/Navigation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: Future.wait([_initialization, DotEnv.load(fileName: ".env")]),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          throw ('Snapshot has an error!!');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Navigation();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
