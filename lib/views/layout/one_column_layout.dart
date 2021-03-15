/*
 * This class is responsible for wraping 
 * a widget in a one column layout. 
 * The widget will take up 2/3rd's of the screen 
 * with 1/3rd white space on both sides
*/
import 'package:flutter/material.dart';

class OneColumnLayout extends StatelessWidget {
  // widget to be wraped
  final Widget widget;

  OneColumnLayout(this.widget, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // white space
        Expanded(
          child: Container(
            height: 1,
          ),
          flex: 1,
        ),
        // Widget
        Expanded(
          child: Padding(
            child: widget,
            // padding above the widget
            padding: EdgeInsets.only(top: 16),
          ),
          flex: 4,
        ),
        // whitespace
        Expanded(
          child: Container(
            height: 1,
          ),
          flex: 1,
        )
      ],
    );
  }
}
