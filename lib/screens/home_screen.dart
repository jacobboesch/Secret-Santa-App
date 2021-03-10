/*
* Defines the home screen
* The screen has two tabs one for viewing participants
* and the other for viewing the households
*/
// imports
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String title = "Secret Santa App";
  final String participantTabTitle = "Participants";
  final String householdTabTitle = "Households";

  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        // Two tabs first one is for viewing participants
        // second one is for viewing households
        child: Scaffold(
            appBar: AppBar(
                title: Text(title),
                // TODO add create button
                bottom: TabBar(
                  tabs: [
                    // participant tab
                    Tab(icon: Icon(Icons.group), text: participantTabTitle),
                    Tab(
                      icon: Icon(Icons.house),
                      text: householdTabTitle,
                    )
                  ],
                )),
            body: TabBarView(
              children: [
                //TODO replace this with actual list
                Center(
                  child: Text("Participant list goes here"),
                ),
                Center(
                  child: Text("Household list goes here"),
                )
              ],
            )));
  }
}
