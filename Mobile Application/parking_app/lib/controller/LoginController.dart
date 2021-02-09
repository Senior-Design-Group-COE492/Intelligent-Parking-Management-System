import 'package:get/get.dart';
import 'package:parking_app/handlers/LoginHandler.dart';

class LoginController extends GetxController {
  bool isSignedIn = LoginHandler.isSignedIn();
  static LoginController get to => Get.find();

  void setIsSignedIn(bool newIsSignedIn) {
    isSignedIn = newIsSignedIn;
    update();
  }
}
