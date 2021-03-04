import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:parking_app/globals/Globals.dart';
import 'package:parking_app/controller/TextFieldController.dart';
import 'package:parking_app/handlers/SearchHandler.dart';
import 'package:parking_app/widgets/FiltersWidget.dart';
import 'package:parking_app/widgets/SearchResultsWidget.dart';

class CustomTextField extends StatelessWidget {
  final FieldController fieldController = Get.put(FieldController());
  final RxString destination = ''.obs;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double widgetWidth =
        Get.width * 0.915; // 343/375 = 0.915 (width from design)

    final double widthPadding = Get.width * 0.043; // 16/375 = 0.043
    final double marginWithStatusBar = statusBarHeight + 16;
    final double originalHeight = 52;
    final double expandedHeight = 385;
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

    final expandedWidget = Obx(() => fieldController.isSearching.value
        ? SearchWidget(
            placesFuture: SearchHandler.searchPlace(destination.value, 'SG'))
        : FiltersWidget());

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
              onSubmitted: (newDestination) {
                destination.value = newDestination;
                fieldController.isSearching.value = true;
                if (!fieldController.isExpanded.value)
                  fieldController.isExpanded.toggle();
              },
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
          Obx(
            () => FloatingActionButton(
              // Can't use IconButton since ripple effect is messed up for it
              // so using FAB with no elevation instead
              hoverElevation: 0,
              disabledElevation: 0,
              highlightElevation: 0,
              focusElevation: 0,
              mini: true,
              elevation: 0,
              child: fieldController.isSearching.value
                  ? Icon(Icons.close, size: 24)
                  : filtersIcon,
              backgroundColor: Colors.transparent,
              onPressed: () {
                // only re-rending widget once instead of twice
                if (fieldController.isSearching.value)
                  fieldController.isSearching.value = false;
                fieldController.isExpanded.toggle();
              },
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
          height: fieldController.isExpanded.value
              ? expandedHeight
              : originalHeight,
          duration: Globals.EXPAND_ANIMATION_DURATION,
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                header,
                fieldController.isExpanded.value
                    ? (expandedWidget)
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
