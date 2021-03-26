/*
* On this screen the user can create or edit a singluar participant
* The user can enter the name, email and household of the participant
* as well as deleting the participant
*/
import 'package:flutter/material.dart';
import 'package:secret_santa_app/models/household.dart';
import 'package:secret_santa_app/models/participant.dart';
import 'package:secret_santa_app/services/participant_service.dart';
import 'package:secret_santa_app/views/form/email_form_field.dart';
import 'package:secret_santa_app/views/form/house_hold_dropdown.dart';
import 'package:secret_santa_app/views/layout/one_column_layout.dart';
import 'package:secret_santa_app/views/form/name_form_field.dart';
import 'package:sqflite/sqflite.dart';

// ignore: must_be_immutable
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

  final List<Household> _households;

  Participant _participant;

  ParticipantScreen(this._households, {Key key})
      : _editMode = false,
        _nameField = NameFormField(),
        _emailField = EmailFormField(),
        _householdDropdown = HouseholdDropdown(),
        super(key: key) {
    this._participant = Participant(null, "", "", "");
    _householdDropdown.households = _households;
  }

  ParticipantScreen.withParticipant(this._households, Participant participant)
      : _editMode = true,
        _nameField = NameFormField.withIntialName(participant.name),
        _emailField = EmailFormField.withInitialEmail(participant.email),
        _householdDropdown =
            HouseholdDropdown.withInitialHousehold(participant.household) {
    this._participant = participant;
    _householdDropdown.households = _households;
  }

  // Saves the current participant
  void _saveParticipant(BuildContext context) async {
    if (_key.currentState.validate()) {
      // update the participant object with information from the form
      _setParticipantFields();
      // if the participant already has an id then we need to update it
      try {
        if (_participant.id != null) {
          await participantService.update(_participant);
        }
        // if there is no id then we need to create the participant
        else {
          await participantService.create(_participant);
        }
        // show that participant saved
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Participant Saved")));
        // return back to the home screen
        Navigator.pop(context);
      } on DatabaseException catch (e) {
        print(e);
        // if we have a duplicate name which gets thrown as a Unique Constraint failure
        if (e.getResultCode() == 2067) {
          // tell the name field that the name is already taken so that it will display
          // the error properly
          _nameField.takenName = _nameField.name;
          // display the taken name error
          _key.currentState.validate();
        }
        // have it go through the unexpect error block
        else {
          throw Exception("Unexpected");
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Unexpected Error Saving Participant")));
        // return back to the home screen
        Navigator.pop(context);
      }
    } else {
      _displayInvalidFormMessage(context);
    }
  }

  // updates the participant object to contain information from the form
  void _setParticipantFields() {
    this._participant.email = _emailField.email;
    this._participant.household = _householdDropdown.selectedHousehold;
    this._participant.name = _nameField.name;
  }

  // informs the user that they need to correct fields in the form
  void _displayInvalidFormMessage(BuildContext context) {
    // change wording of message
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Please fix invalid fields")));
  }

  void _deleteParticipant(BuildContext context) async {
    try {
      await participantService.delete(_participant);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Participant Deleted")));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unexpected Error Deleting Participant")));
    }
    // get out of the dialog
    Navigator.pop(context);
    // pop again to get back to the home screen
    Navigator.pop(context);
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
                    onPressed: () => {_deleteParticipant(context)},
                    child: Text(_deleteConfirmationConfirmText))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
