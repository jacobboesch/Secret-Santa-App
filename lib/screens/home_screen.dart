/*
* Defines the home screen
* The screen has two tabs one for viewing participants
* and the other for viewing the households.
* The home screen displays the list of participants and households
* it also has a button to create a participant/household 
* Finally it has a button to send the emails
*/
// imports
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:secret_santa_app/models/household.dart';
import 'package:secret_santa_app/screens/household_screen.dart';
import 'package:secret_santa_app/screens/participant_screen.dart';
import '../models/participant.dart';
import '../models/household.dart';

final List<Participant> _participants = [
  Participant.withoutId("Jacob", "Home", "jacobtboesch@gmail.com"),
  Participant.withoutId("James", "Cousins House", "james@example.com"),
  Participant.withoutId("Jessica", "Cousins House", "Jessica@example.com"),
  Participant.withoutId("Julie", "Cousins House", "julie@example.com"),
  Participant.withoutId("Grandma", "Grandma's House", "Grandma@example.com"),
  Participant.withoutId("Grandpa", "Grandma's House", "Grandpa@example.com"),
  Participant.withoutId("Mom", "Home", "mom@example.com"),
  Participant.withoutId("Jeremy", "Home", "jeremy@example.com")
];

final List<Household> _households = [
  Household("Home"),
  Household("Cousins House"),
  Household("Grandma's House")
];

class HomeScreen extends StatelessWidget {
  // constants
  final String title = "Secret Santa App";
  final String participantTabTitle = "Participants";
  final String householdTabTitle = "Households";
  // tab index
  static const int PARTICIPANT_TAB_INDEX = 0;
  static const int HOUSEHOLD_TAB_INDEX = 1;

  // participant list item view
  Widget _participantItemBuilder(
      BuildContext context, Participant participant) {
    return ListTile(
        // adds 64dp of padding to the left of each list item
        contentPadding: const EdgeInsets.only(left: 64.0),
        title: Text(participant.name),
        subtitle: Text(participant.email));
  }

  // returns household list item
  Widget _householdItemBuilder(BuildContext context, int index) {
    return ListTile(
        contentPadding: const EdgeInsets.only(left: 32),
        title: Text(_households[index].household));
  }

  // returns a divider for the prticipant list based on the house hold
  Widget _householdDivider(String household) {
    return Column(
      children: [
        Divider(indent: 16),
        Container(
          padding: EdgeInsets.only(left: 16),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                household,
                textAlign: TextAlign.start,
              )),
        )
      ],
    );
  }

  // called when the create button is tapped on either tab
  // determines weather to create a participant or household and takes
  // the user to the approprate screen
  void _onCreateButtonTapped(BuildContext context) {
    // determine which tab we're on
    int tabIndex = DefaultTabController.of(context).index;
    if (tabIndex == PARTICIPANT_TAB_INDEX) {
      // navigate to the participant screen
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ParticipantScreen()));
    } else {
      // navigate to the household screen
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HouseholdScreen()));
    }
  }

  // called when the send emails button is clicked
  // prompts the user to confirm wheather or not whey want to send the
  // emails then sends out the emails to all of the participants
  void _onSendEmailButtonTapped(BuildContext context) {
    //TODO replace with actual code
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Send Email Button Cliked")));
  }

  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(title),
          actions: [
            // Create button
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () => {_onCreateButtonTapped(context)},
                  child: Icon(Icons.add, size: 26),
                ))
          ],
          bottom: TabBar(
            tabs: [
              // participant tab
              Tab(icon: Icon(Icons.group), text: participantTabTitle),
              // household tab
              Tab(
                icon: Icon(Icons.house),
                text: householdTabTitle,
              )
            ],
          )),
      body: TabBarView(
        children: [
          // Participant List grouped by household
          GroupedListView<Participant, String>(
            elements: _participants,
            groupBy: (participant) => participant.household,
            groupSeparatorBuilder: _householdDivider,
            itemBuilder: _participantItemBuilder,
          ),
          // Household list
          ListView.builder(
              itemCount: _households.length,
              itemExtent: 60,
              itemBuilder: _householdItemBuilder)
        ],
      ),
      // TODO have action button not block the list view
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _onSendEmailButtonTapped(context);
          },
          label: Text("Send Emails")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
