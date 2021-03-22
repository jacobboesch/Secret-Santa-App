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
import 'package:secret_santa_app/models/participant.dart';
import 'package:secret_santa_app/services/household_service.dart';
import 'package:secret_santa_app/services/participant_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // constants
  final String title = "Secret Santa App";
  final String participantTabTitle = "Participants";
  final String householdTabTitle = "Households";
  List<Participant> _participants = [];
  List<Household> _households = [];

  final ParticipantService _participantService = ParticipantService();
  final HouseholdService _householdService = HouseholdService();
  // tab index
  static const int PARTICIPANT_TAB_INDEX = 0;
  static const int HOUSEHOLD_TAB_INDEX = 1;

  _HomeScreenState() {
    updateParticipantList();
    updateHouseholdList();
  }

  // retrives a list of participants then updates the screen with the list
  // method is called asyncronously so that it's on it's own thread.
  Future<void> updateParticipantList() async {
    _participants = await _participantService.fetchAll();
    // refresh the screen
    setState(() {});
  }

  Future<void> updateHouseholdList() async {
    _households = await _householdService.fetchAll();
    setState(() {});
  }

  // called when participant item is tapped
  void _onParticipantItemTaped(
      BuildContext context, Participant participant) async {
    // navigate to participant screen sending participant information
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ParticipantScreen.withParticipant(_households, participant)));
    // refresh the list of participants
    updateParticipantList();
  }

  // participant list item view
  Widget _participantItemBuilder(
      BuildContext context, Participant participant) {
    return ListTile(
      // adds 64dp of padding to the left of each list item
      contentPadding: const EdgeInsets.only(left: 64.0),
      title: Text(participant.name),
      subtitle: Text(participant.email),
      // navigate to participant screen
      onTap: () {
        _onParticipantItemTaped(context, participant);
      },
    );
  }

  void _onHouseholdItemTapped(Household household) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HouseholdScreen.withHousehold(household)));
    updateHouseholdList();
    updateParticipantList();
  }

  // returns household list item
  Widget _householdItemBuilder(BuildContext context, int index) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 32),
      title: Text(_households[index].household),
      onTap: () => {_onHouseholdItemTapped(_households[index])},
    );
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
  void _onCreateButtonTapped(BuildContext context) async {
    // determine which tab we're on
    int tabIndex = DefaultTabController.of(context).index;
    if (tabIndex == PARTICIPANT_TAB_INDEX) {
      // navigate to the participant screen
      // and wait for the return
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ParticipantScreen(_households)));
      // when we return from the participant screen refresh the list of participants
      updateParticipantList();
    } else {
      // navigate to the household screen
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => HouseholdScreen()));
      updateHouseholdList();
      updateParticipantList();
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
