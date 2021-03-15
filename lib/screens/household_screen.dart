/*
* This screen allows the user to define a new household
*/

import 'package:flutter/material.dart';

class HouseholdScreen extends StatelessWidget {
  HouseholdScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Household"),
        ),
        body: Center(
          child: Text("Hello World"),
        ));
  }
}
