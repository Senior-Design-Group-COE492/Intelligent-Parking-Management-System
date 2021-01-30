import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';

class CustomTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = new TextEditingController();
    final String assetName = 'assets/icons/filtersIcon.svg';
    final Widget filtersIcon = SvgPicture.asset(
      assetName,
      semanticsLabel: 'filters Icon',
    );

    // TODO: add the top padding and width padding on the sides and fix some
    // styling when the text field is added to the Maps Screen
    return Container(
      height: 80,
      color: Colors.white,
      child: Container(
        child: Row(
          children: [
            SizedBox(
              width: 200,
              child: ExpandablePanel(
                header: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(
                        CupertinoIcons.search,
                        color: Color(0xCC000000),
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
                  ],
                ),
                hasIcon: false,
                collapsed: Row(
                  children: [
                    ExpandableButton(
                      child: filtersIcon,
                    ),
                  ],
                ),
                expanded: Row(
                  children: [
                    Text('Hello'),
                    ExpandableButton(
                      child: filtersIcon,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
