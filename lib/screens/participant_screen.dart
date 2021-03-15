/*
* On this screen the user can create or edit a singluar participant
* The user can enter the name, email and household of the participant
* as well as deleting the participant
*/
import 'package:flutter/material.dart';
import 'package:secret_santa_app/models/household.dart';
import 'package:secret_santa_app/views/form/email_form_field.dart';
import 'package:secret_santa_app/views/form/house_hold_dropdown.dart';
import 'package:secret_santa_app/views/layout/one_column_layout.dart';
import 'package:secret_santa_app/views/form/name_form_field.dart';

class ParticipantScreen extends StatelessWidget {
  // constants
  final String title = "Participant";
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final NameFormField _nameField = new NameFormField();
  final EmailFormField _emailField = new EmailFormField();
  final HouseholdDropdown _householdDropdown = HouseholdDropdown([
    Household("Home"),
    Household("Cousins House"),
    Household("Grandma's House")
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // TODO add toolbar to the app bar
        appBar: AppBar(title: Text(this.title)),
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
                ])));
  }
}
