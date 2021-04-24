import 'package:get/get.dart';

class FieldController extends GetxController {
  RxDouble distanceSliderValue = 500.0.obs;
  distanceChangeSlider(double value) => {
        distanceSliderValue.value = value,
        update(),
      };

  RxDouble timeSliderValue = 15.0.obs;
  timeChangeSlider(double value) => {
        timeSliderValue.value = value,
        update(),
      };

  RxDouble gantrySliderValue = 180.0.obs;
  gantryChangeSlder(double value) => {
        gantrySliderValue.value = value,
        update(),
      };

  int freeGroupValue = 1;
  RxInt freeRadioValue = 0.obs;
  changeFreeRadio(dynamic newValue) {
    freeRadioValue.value = newValue;
    freeGroupValue = newValue;
    update();
    print(freeGroupValue);
    print(freeRadioValue.value);
  }

  int nightGroupValue = 1;
  RxInt nightRadioValue = 0.obs;
  changeNightRadio(dynamic newValue) {
    nightRadioValue.value = newValue;
    nightGroupValue = newValue;
    update();
    print(nightGroupValue);
    print(nightRadioValue.value);
  }

  int parkingTypeGroupValue = 1;
  RxInt parkingTypeRadioValue = 0.obs;
  changeParkingTypeRadio(dynamic newValue) {
    parkingTypeRadioValue.value = newValue;
    parkingTypeGroupValue = newValue;
    update();
    print(parkingTypeRadioValue.value);
  }

  RxBool isSurface = false.obs;
  RxBool isMechanised = false.obs;
  RxBool isCovered = false.obs;
  RxBool isBasement = false.obs;
  RxBool isMultiStorey = false.obs;
  RxBool isFree = false.obs;
  RxBool isSearching = false.obs;
  RxBool isExpanded = false.obs;
  RxBool isNight = false.obs;
  RxBool isElectronic = false.obs;

  static FieldController get to => Get.find();
}
