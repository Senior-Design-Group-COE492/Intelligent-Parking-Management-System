import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:parking_app/globals/Globals.dart';
import 'package:parking_app/controller/TextFieldController.dart';

class CustomTextField extends StatelessWidget {
  final RxBool isExpanded = false.obs;
  String distanceSliderValueLabelMaker(double sliderValue) {
    if (sliderValue < 1000)
      return sliderValue.round().toString() + ' m';
    else
      return (sliderValue / 1000).toStringAsFixed(1) + ' km';
  }

  String timeSliderValueLabelMaker(double sliderValue) {
    if (sliderValue < 60)
      return sliderValue.toStringAsFixed(0).toString() + ' min';
    else if (sliderValue >= 60 && sliderValue < 120) {
      return '1:' +
          (sliderValue % 60).toStringAsFixed(0).toString().padLeft(2, '0') +
          ' hrs';
    } else {
      return '2:00 hrs';
    }
  }

  @override
  Widget build(BuildContext context) {
    final FieldController fieldController = Get.put(FieldController());
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double widgetWidth =
        Get.width * 0.915; // 343/375 = 0.915 (width from design)
    final double checkBoxRowWidth = Get.width * 0.274;
    double checkBoxLabelFontSize = 14;
    if (Get.width < 385) checkBoxLabelFontSize = 13;
    if (Get.width < 330) checkBoxLabelFontSize = 10;

    final double widthPadding = Get.width * 0.043; // 16/375 = 0.043
    final double marginWithStatusBar = statusBarHeight + 16;
    final double originalHeight = 52;
    final double expandedHeight = 385;
    final TextEditingController _controller = new TextEditingController();
    final String assetName = 'assets/icons/filtersIcon.svg';

    final sliderThemeData = SliderThemeData(
      thumbColor: context.theme.primaryColor,
      inactiveTrackColor: Colors.grey[300],
      inactiveTickMarkColor: Colors.grey,
      activeTrackColor: context.theme.primaryColor,
      activeTickMarkColor: context.theme.primaryColor,
      overlayColor: Colors.black12,
    );
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

    Widget _checkBox(myValue, toggleValue, text) {
      return Container(
        width: checkBoxRowWidth,
        child: Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: Checkbox(
                value: myValue,
                onChanged: (bool value) {
                  toggleValue.toggle();
                },
                checkColor: Colors.white,
                activeColor: context.theme.primaryColor,
              ),
            ),
            Text(text, style: TextStyle(fontSize: checkBoxLabelFontSize)),
          ],
        ),
      );
    }

    Widget _radioListTile(myWidth, grpValue, changeFun, val, text) {
      return Row(children: [
        Radio(
          activeColor: context.theme.primaryColor,
          value: val,
          groupValue: grpValue,
          onChanged: changeFun,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 14),
        ),
      ]);
    }

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
                          Text('Time Till Arrival'),
                          SliderTheme(
                            data: sliderThemeData,
                            child: Slider(
                              value: fieldController.timeSliderValue.value,
                              min: 15.0,
                              max: 120.0,
                              divisions: 7,
                              label: timeSliderValueLabelMaker(
                                  fieldController.timeSliderValue.value),
                              onChanged: fieldController.timeChangeSlider,
                            ),
                          ),
                          Text('Distance (max.)'),
                          SliderTheme(
                            data: sliderThemeData,
                            child: Slider(
                              value: fieldController.distanceSliderValue.value,
                              min: 100,
                              max: 1500,
                              divisions: 14,
                              label: distanceSliderValueLabelMaker(
                                  fieldController.distanceSliderValue.value),
                              onChanged: fieldController.distanceChangeSlider,
                            ),
                          ),
                          Text('Parking Type'),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                          ),
                          Row(
                            children: [
                              _checkBox(fieldController.isSurface.value,
                                  fieldController.isSurface, 'Surface'),
                              _checkBox(fieldController.isMechanised.value,
                                  fieldController.isMechanised, 'Mechanised'),
                              _checkBox(fieldController.isCovered.value,
                                  fieldController.isCovered, 'Covered'),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                          ),
                          Row(
                            children: [
                              _checkBox(fieldController.isBasement.value,
                                  fieldController.isBasement, 'Basement'),
                              _checkBox(
                                  fieldController.isMultiStorey.value,
                                  fieldController.isMultiStorey,
                                  'Multi-Storey'),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                          ),
                          Text('Free only'),
                          GetBuilder<FieldController>(
                            builder: (_) => Row(
                              children: [
                                _radioListTile(
                                    125.0,
                                    fieldController.groupValue,
                                    fieldController.changeRadio,
                                    1,
                                    'Yes'),
                                _radioListTile(
                                    120.0,
                                    fieldController.groupValue,
                                    fieldController.changeRadio,
                                    0,
                                    'No'),
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
