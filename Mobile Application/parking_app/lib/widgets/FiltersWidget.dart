import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_app/controller/TextFieldController.dart';

class FiltersWidget extends StatelessWidget {
  final FieldController fieldController = Get.put(FieldController());

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

  String gantrySliderValueLabelMarker(double sliderValue) {
    if (sliderValue < 1000)
      return (sliderValue / 100).toStringAsFixed(2).toString() + ' m';
    else
      return (sliderValue / 100).toStringAsFixed(2) + ' m';
  }

  @override
  Widget build(BuildContext context) {
    final double checkBoxRowWidth = Get.width * 0.274;
    double checkBoxLabelFontSize = 14;
    if (Get.width < 385) checkBoxLabelFontSize = 13;
    if (Get.width < 330) checkBoxLabelFontSize = 10;

    final _primaryColor = Theme.of(context).primaryColor;
    final sliderThemeData = SliderThemeData(
      thumbColor: _primaryColor,
      inactiveTrackColor: Colors.grey[300],
      inactiveTickMarkColor: Colors.grey,
      activeTrackColor: _primaryColor,
      activeTickMarkColor: _primaryColor,
      overlayColor: Colors.black12,
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
                activeColor: _primaryColor,
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
          activeColor: _primaryColor,
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

    return Column(
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
        Text('Gantry Height (max.)'),
        SliderTheme(
          data: sliderThemeData,
          child: Slider(
            value: fieldController.gantrySliderValue.value,
            min: 180,
            max: 1000,
            divisions: 20,
            label: gantrySliderValueLabelMarker(
                fieldController.gantrySliderValue.value),
            onChanged: fieldController.gantryChangeSlder,
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
            _checkBox(fieldController.isMultiStorey.value,
                fieldController.isMultiStorey, 'Multi-Storey'),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
        ),
        Text('Free only'),
        GetBuilder<FieldController>(
          builder: (_) => Row(
            children: [
              _radioListTile(125.0, fieldController.groupValue,
                  fieldController.changeRadio, 1, 'Yes'),
              _radioListTile(120.0, fieldController.groupValue,
                  fieldController.changeRadio, 0, 'No'),
            ],
          ),
        ),
        Text('Night Parking'),
        GetBuilder<FieldController>(
          builder: (_) => Row(
            children: [
              _radioListTile(125.0, fieldController.groupValue,
                  fieldController.changeRadio, 1, 'Yes'),
              _radioListTile(120.0, fieldController.groupValue,
                  fieldController.changeRadio, 0, 'No'),
            ],
          ),
        ),
      ],
    );
  }
}
