import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MapsController extends GetxController {
  // below link to docs explains how to make and use controllers
  // https://github.com/jonataslaw/getx/blob/master/documentation/en_US/state_management.md#simple-state-manager
  Position currentLocation;
  static MapsController get to => Get.find();

  void setCurrentLocation(newCurrentLocation) {
    print(currentLocation);
    currentLocation = newCurrentLocation;
    update();
    print(currentLocation);
  }
}
