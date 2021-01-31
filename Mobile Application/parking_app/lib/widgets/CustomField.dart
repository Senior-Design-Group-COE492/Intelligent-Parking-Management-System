import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SliderController extends GetxController {
  RxDouble sliderValue = 20.0.obs;
  changeSlider(double value) => {
        sliderValue.update((value) {
          sliderValue.value = value;
        }),
      };
}

class RadioController extends GetxController {
  var groupValue = [0, 1].obs;
  RxInt radioValue = 0.obs;
  changeRadio(dynamic value) {
    radioValue.update((newValue) {
      switch (newValue) {
        case 1:
          radioValue.value = 1;
          break;
        default:
          radioValue.value = 0;
      }
      print(radioValue.value);
    });
  }
}

class CustomTextField extends StatelessWidget {
  RxBool isExpanded = false.obs;
  RxBool isSurface = false.obs;
  RxBool isMechanised = false.obs;
  RxBool isCovered = false.obs;
  RxBool isBasement = false.obs;
  RxBool isMultiStorey = false.obs;
  RxBool isFree = false.obs;

  @override
  Widget build(BuildContext context) {
    final SliderController sliderController = Get.put(SliderController());
    final RadioController radioController = Get.put(RadioController());
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double widgetWidth =
        Get.width * 0.915; // 343/375 = 0.915 (width from design)
    final double widthPadding = Get.width * 0.043; // 16/375 = 0.043
    final double marginWithStatusBar = statusBarHeight + 36;
    final double originalHeight = 52;
    final double expandedHeight = Get.height - marginWithStatusBar - 70 - 36;
    final TextEditingController _controller = new TextEditingController();
    final String assetName = 'assets/icons/filtersIcon.svg';
    final Widget filtersIcon = SvgPicture.asset(
      assetName,
      semanticsLabel: 'filters Icon',
    );

    // TODO: add the top padding and width padding on the sides and fix some
    // styling when the text field is added to the Maps Screen
    final Widget header = Container(
      color: Colors.white,
      height: originalHeight,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
          Flexible(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter Destination',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: FloatingActionButton(
              // Can't use IconButton since ripple effect is messed up for it
              // so using FAB with no elevation instead
              hoverElevation: 0,
              disabledElevation: 0,
              highlightElevation: 0,
              focusElevation: 0,
              mini: true,
              elevation: 0,
              child: filtersIcon,
              backgroundColor: Colors.transparent,
              // TODO: implement onPressed
              onPressed: () => isExpanded.toggle(),
            ),
          ),
        ],
      ),
    );

    return Align(
      alignment: Alignment.topCenter,
      child: Obx(
        () => AnimatedContainer(
          padding: EdgeInsets.only(left: widthPadding, right: widthPadding),
          width: widgetWidth,
          margin: EdgeInsets.only(top: marginWithStatusBar),
          height: isExpanded.value ? expandedHeight : originalHeight,
          duration: Duration(milliseconds: 150),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                header,
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Text('Distance (max.)'),
                Slider(
                  value: sliderController.sliderValue.value,
                  min: 0,
                  max: 100,
                  divisions: 5,
                  label: sliderController.sliderValue.value.round().toString(),
                  onChanged: sliderController.changeSlider,
                  activeColor: context.theme.primaryColor,
                  inactiveColor: Colors.grey,
                ),
                Text('Parking Type'),
                Row(
                  children: [
                    Checkbox(
                      value: isSurface.value,
                      checkColor: context.theme.primaryColor,
                      onChanged: (bool value) {
                        isSurface.toggle();
                      },
                    ),
                    Text('Surface'),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Checkbox(
                      value: isMechanised.value,
                      checkColor: context.theme.primaryColor,
                      onChanged: (bool value) {
                        isMechanised.toggle();
                      },
                    ),
                    Text('Mechanised'),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Checkbox(
                      value: isCovered.value,
                      activeColor: context.theme.primaryColor,
                      onChanged: (bool value) {
                        isCovered.toggle();
                      },
                    ),
                    Text('Covered'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isBasement.value,
                      checkColor: context.theme.primaryColor,
                      onChanged: (bool value) {
                        isBasement.toggle();
                      },
                    ),
                    Text('Basement'),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Checkbox(
                      value: isMultiStorey.value,
                      checkColor: context.theme.primaryColor,
                      onChanged: (bool value) {
                        isMultiStorey.toggle();
                      },
                    ),
                    Text('Multi-Storey'),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: ListTile(
                        title: Text('Yes'),
                        leading: Radio(
                          value: 1,
                          groupValue: radioController.groupValue,
                          onChanged: radioController.changeRadio,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: ListTile(
                        title: Text('No'),
                        leading: Radio(
                            value: 0,
                            groupValue: radioController.groupValue,
                            onChanged: radioController.changeRadio),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
