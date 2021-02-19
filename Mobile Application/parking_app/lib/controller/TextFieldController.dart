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

  int groupValue = 1;
  RxInt radioValue = 0.obs;
  changeRadio(dynamic newValue) {
    radioValue.value = newValue;
    groupValue = newValue;
    update();
  }

  RxBool isSurface = false.obs;
  RxBool isMechanised = false.obs;
  RxBool isCovered = false.obs;
  RxBool isBasement = false.obs;
  RxBool isMultiStorey = false.obs;
  RxBool isFree = false.obs;
  RxBool isSearching = false.obs;
  RxBool isExpanded = false.obs;
}
