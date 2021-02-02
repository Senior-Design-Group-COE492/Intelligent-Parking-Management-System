import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:parking_app/globals/Globals.dart';

class SliderController extends GetxController {
  RxDouble sliderValue = 500.0.obs;
  changeSlider(double value) => {
        sliderValue.value = value,
        update(),
        print(sliderValue.value),
      };
}

class RadioController extends GetxController {
  int groupValue = 1;
  RxInt radioValue = 0.obs;
  changeRadio(dynamic newValue) {
    radioValue.value = newValue;
    groupValue = newValue;
    update();
    print(radioValue.value);
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

  String sliderValueLabelMaker(double sliderValue) {
    if (sliderValue < 1000)
      return sliderValue.round().toString() + ' m';
    else
      return (sliderValue / 1000).toStringAsFixed(1) + ' km';
  }

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
    final double expandedHeight = 320;
    final TextEditingController _controller = new TextEditingController();
    final String assetName = 'assets/icons/filtersIcon.svg';

    final Widget filtersIcon = SvgPicture.asset(
      assetName,
      semanticsLabel: 'filters Icon',
    );
    final verticalDivider = VerticalDivider(
      color: Colors.grey[200],
      width: 15,
      thickness: 1,
    );

    final Widget header = Container(
      height: originalHeight,
      child: Row(
        children: [
          Icon(
            CupertinoIcons.search,
            color: Color.fromRGBO(0, 0, 0, 0.8),
            size: 30,
          ),
          Container(
            height: 30,
            child: verticalDivider,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
          ),
          Flexible(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter Destination',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(),
            ),
          ),
          Container(
            height: 30,
            child: verticalDivider,
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
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.9),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(12, 0),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: widthPadding, right: widthPadding),
          width: widgetWidth,
          margin: EdgeInsets.only(top: marginWithStatusBar),
          height: isExpanded.value ? expandedHeight : originalHeight,
          duration: Globals.EXPAND_ANIMATION_DURATION,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                header,
                isExpanded.value
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                          ),
                          Text('Distance (max.)'),
                          Slider(
                            value: sliderController.sliderValue.value,
                            min: 100,
                            max: 1500,
                            divisions: 14,
                            label: sliderValueLabelMaker(
                                sliderController.sliderValue.value),
                            onChanged: sliderController.changeSlider,
                            inactiveColor: Color(0xFFFFBFA0),
                            activeColor: context.theme.primaryColor,
                          ),
                          Text('Parking Type'),
                          Row(
                            children: [
                              Checkbox(
                                value: isSurface.value,
                                checkColor: Colors.white,
                                activeColor: context.theme.primaryColor,
                                onChanged: (bool value) {
                                  isSurface.toggle();
                                },
                              ),
                              Text('Surface'),
                              Padding(
                                padding: EdgeInsets.only(left: 12),
                              ),
                              Checkbox(
                                value: isMechanised.value,
                                checkColor: Colors.white,
                                activeColor: context.theme.primaryColor,
                                onChanged: (bool value) {
                                  isMechanised.toggle();
                                },
                              ),
                              Text('Mechanised'),
                              Checkbox(
                                value: isCovered.value,
                                activeColor: context.theme.primaryColor,
                                checkColor: Colors.white,
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
                                checkColor: Colors.white,
                                activeColor: context.theme.primaryColor,
                                onChanged: (bool value) {
                                  isBasement.toggle();
                                },
                              ),
                              Text('Basement'),
                              Checkbox(
                                value: isMultiStorey.value,
                                checkColor: Colors.white,
                                activeColor: context.theme.primaryColor,
                                onChanged: (bool value) {
                                  isMultiStorey.toggle();
                                },
                              ),
                              Text('Multi-Storey'),
                            ],
                          ),
                          Text('Free only'),
                          GetBuilder<RadioController>(
                            builder: (_) => Row(
                              children: [
                                SizedBox(
                                  width: 125,
                                  child: ListTile(
                                    title: Text('Yes'),
                                    leading: Radio(
                                      value: 1,
                                      groupValue: radioController.groupValue,
                                      onChanged: radioController.changeRadio,
                                      activeColor: context.theme.primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: ListTile(
                                    title: Text('No'),
                                    leading: Radio(
                                      activeColor: context.theme.primaryColor,
                                      value: 0,
                                      groupValue: radioController.groupValue,
                                      onChanged: radioController.changeRadio,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
