import 'package:get/get.dart';

class FieldController extends GetxController {
  RxDouble sliderValue = 500.0.obs;
  changeSlider(double value) => {
        sliderValue.value = value,
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
}
