import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:parking_app/globals/Globals.dart';
import 'package:parking_app/controller/TextFieldController.dart';

class CustomTextField extends StatelessWidget {
  RxBool isExpanded = false.obs;
  String sliderValueLabelMaker(double sliderValue) {
    if (sliderValue < 1000)
      return sliderValue.round().toString() + ' m';
    else
      return (sliderValue / 1000).toStringAsFixed(1) + ' km';
  }

  @override
  Widget build(BuildContext context) {
    final FieldController fieldController = Get.put(FieldController());
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double widgetWidth =
        Get.width * 0.915; // 343/375 = 0.915 (width from design)
    final double checkBoxPadding = Get.width * 0.0426;
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

    Widget _checkBox(myValue, toggleValue) {
      return Container(
        width: 50,
        height: 50,
        child: Checkbox(
          value: myValue,
          onChanged: (bool value) {
            toggleValue.toggle();
            print(toggleValue);
          },
          checkColor: Colors.white,
          activeColor: context.theme.primaryColor,
        ),
      );
    }

    Widget _radioListTile(myWidth, grpValue, changeFun, val, text) {
      return Container(
        width: myWidth as double,
        child: ListTile(
          title: Text(text),
          leading: Radio(
            activeColor: context.theme.primaryColor,
            value: val,
            groupValue: grpValue,
            onChanged: changeFun,
          ),
        ),
      );
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
                          Text('Distance (max.)'),
                          Slider(
                            value: fieldController.sliderValue.value,
                            min: 100,
                            max: 1500,
                            divisions: 14,
                            label: sliderValueLabelMaker(
                                fieldController.sliderValue.value),
                            onChanged: fieldController.changeSlider,
                            inactiveColor: Colors.grey[300],
                            activeColor: context.theme.primaryColor,
                          ),
                          Text('Parking Type'),
                          Row(
                            children: [
                              _checkBox(fieldController.isSurface.value,
                                  fieldController.isSurface),
                              Text('Surface'),
                              _checkBox(fieldController.isMechanised.value,
                                  fieldController.isMechanised),
                              Text('Mechanised'),
                              _checkBox(fieldController.isCovered.value,
                                  fieldController.isCovered),
                              Text('Covered'),
                            ],
                          ),
                          Row(
                            children: [
                              _checkBox(fieldController.isBasement.value,
                                  fieldController.isBasement),
                              Text('Basement'),
                              _checkBox(fieldController.isMultiStorey.value,
                                  fieldController.isMultiStorey),
                              Text('Multi-Storey'),
                            ],
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
