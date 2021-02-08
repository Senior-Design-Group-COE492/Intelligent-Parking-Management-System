import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/App.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp(
      home: App(),
      theme: ThemeData(
        primaryColor: Color(0xFFFF8E71),
        accentColor: Color(0xFF7ACAFF),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
