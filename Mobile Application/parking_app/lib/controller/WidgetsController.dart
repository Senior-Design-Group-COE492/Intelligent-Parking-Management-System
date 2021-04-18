import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';

class WidgetsController extends GetxController {
  // below link to docs explains how to make and use controllers
  // https://github.com/jonataslaw/getx/blob/master/documentation/en_US/state_management.md#simple-state-manager
  // use GetBuilder when actually using the controller
  // use MapsController.to.func() for functions
  bool isHidden = false;
  bool isParkingInfo =
      false; // info window shown when true, textfield shown when false
  String parkingId = '';
  bool isLoading = true;

  final availableMapsFuture = MapLauncher.installedMaps;
  static WidgetsController get to => Get.find();

  void setIsLoading(bool isLoading) {
    this.isLoading = isLoading;
    update();
  }

  void toggleIsHidden() {
    isHidden = !isHidden;
    update();
  }

  void hideInfoWindow() {
    parkingId = '';
    isParkingInfo = false;
    update();
  }

  void showInfoWindow(String parkingId) {
    // updates parking id to show the appropriate information in the info window
    // also enables the infoWindow
    this.parkingId = parkingId;
    isParkingInfo = true;
    update();
  }
}
