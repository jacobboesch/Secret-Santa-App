/*
* On this screen the user can create or edit a singluar participant
* The user can enter the name, email and household of the participant
* as well as deleting the participant
*/
import 'package:flutter/material.dart';
import 'package:secret_santa_app/models/participant.dart';
import 'package:secret_santa_app/services/participant_service.dart';
import 'package:secret_santa_app/views/form/email_form_field.dart';
import 'package:secret_santa_app/views/form/house_hold_dropdown.dart';
import 'package:secret_santa_app/views/layout/one_column_layout.dart';
import 'package:secret_santa_app/views/form/name_form_field.dart';

class ParticipantScreen extends StatelessWidget {
  // constants
  final String title = "Participant";
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final NameFormField _nameField;
  final EmailFormField _emailField;
  final HouseholdDropdown _householdDropdown;
  final bool _editMode;

  final String _deleteConfirmationTitle = "Delete participant?";
  final String _deleteConfirmationHelperText =
      "The participant will be permanently removed from the list of participants";
  final String _deleteConfirmationCancelText = "CANCEL";
  final String _deleteConfirmationConfirmText = "DELETE";

  final ParticipantService participantService = ParticipantService();

  static final _households = ["Home", "Cousins House", "Grandma's House"];

  Participant participant;

  ParticipantScreen({Key key})
      : _editMode = false,
        _nameField = NameFormField(),
        _emailField = EmailFormField(),
        _householdDropdown = HouseholdDropdown(_households),
        super(key: key);

  ParticipantScreen.withParticipant(Participant participant)
      : _editMode = true,
        _nameField = NameFormField.withIntialName(participant.name),
        _emailField = EmailFormField.withInitialEmail(participant.email),
        _householdDropdown = HouseholdDropdown.withInitialHousehold(
            _households, participant.household) {
    this.participant = participant;
  }

  // Saves the current participant
  void _saveParticipant(BuildContext context) {
    // TODO add error checking
    // TODO write code to save the participant
    participant = new Participant.withoutId(_nameField.name,
        _householdDropdown.selectedHousehold, _emailField.email);
    participantService.create(participant);
    // show that participant saved
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Participant Saved")));
    // return back to the home screen
    Navigator.pop(context, true);
  }

  void _deleteParticipant(BuildContext context) {
    // TODO wrie code for delete participant
  }

  // called when the delete button is pressed
  void _confirmDelete(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(_deleteConfirmationTitle),
              content: Text(_deleteConfirmationHelperText),
              actions: [
                TextButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: Text(_deleteConfirmationCancelText)),
                TextButton(
                    onPressed: () => {
                          // TODO replace with async call
                          _deleteParticipant(context)
                        },
                    child: Text(_deleteConfirmationConfirmText))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO add toolbar to the app bar
      appBar: AppBar(
        title: Text(this.title),
        actions: _editMode
            ? [
                // Delete button
                // Only shows up in edit mode
                Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () => {_confirmDelete(context)},
                      child: Icon(Icons.delete_forever, size: 26),
                    ))
              ]
            : null,
      ),
      // participant form
      body: Form(
          key: _key, // asign the form key
          // have the form validate each field after the user interacts with it
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
              // align items in the center of the screen
              crossAxisAlignment: CrossAxisAlignment.center,
              // participant form
              children: [
                OneColumnLayout(_nameField),
                OneColumnLayout(_emailField),
                OneColumnLayout(_householdDropdown)
              ])),
      bottomSheet: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton.icon(
                onPressed: () {
                  _saveParticipant(context);
                },
                icon: Icon(Icons.save),
                label: Text("SAVE")),
          )
        ],
      ),
    );
  }
}
