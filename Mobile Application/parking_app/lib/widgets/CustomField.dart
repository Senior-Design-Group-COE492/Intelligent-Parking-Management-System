import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

// class SliderController extends GetxController {
//   var sliderValue = 20.0.obs;
//   change(RxDouble value) => sliderValue = value;
// }

class CustomTextField extends StatelessWidget {
  RxBool isExpanded = false.obs;

  @override
  Widget build(BuildContext context) {
    // final SliderController c = Get.put(SliderController());
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double widgetWidth =
        Get.width * 0.915; // 343/375 = 0.915 (width from design)
    final double widthPadding = Get.width * 0.043; // 16/375 = 0.043
    final double marginWithStatusBar = statusBarHeight + 36;
    final double originalHeight = 3;
    final double expandedHeight = Get.height - marginWithStatusBar - 70 - 36;
    final TextEditingController _controller = new TextEditingController();
    final String assetName = 'assets/icons/filtersIcon.svg';
    final Widget filtersIcon = SvgPicture.asset(
      assetName,
      semanticsLabel: 'filters Icon',
    );

    // TODO: add the top padding and width padding on the sides and fix some
    // styling when the text field is added to the Maps Screen
    final Widget header = Row(
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
          child: filtersIcon,
        ),
      ],
    );

    // TODO: implement build
    return GestureDetector(
      onTap: () => {
        isExpanded.toggle(),
        print(isExpanded.value),
      },
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
                Text('Distance (max.)'),
                // Slider(
                //   value: c.sliderValue as double,
                //   min: 0,
                //   max: 100,
                //   divisions: 10,
                //   label: c.sliderValue.round().toString(),
                //   onChanged: c.change,
                // )
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
                Text('Parking Type'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
