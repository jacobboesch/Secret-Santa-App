/*
* Textfield for name input
* this class is responsible for validating the name input 
* and how the textbox is presented
*/

import 'package:flutter/material.dart';

class NameFormField extends StatelessWidget {
  // one to unlimited alphabetical and space characters
  final String namePattern = "^[a-zA-Z ]+";
  // error message for empty name
  final String emptyErrorMessage = "Error: Name can't be empty";

  final String invalidNameMessage =
      "Error: Name can only contain alphabetical characters";

  final String label = "Name";

  final String helperText = "*Required";

  final TextEditingController textController = TextEditingController();

  NameFormField({Key key}) : super(key: key);

  String _validateName(String name) {
    RegExp regex = RegExp(namePattern);
    // first check if the name is empty
    if (name.isEmpty) {
      return emptyErrorMessage;
    } else if (regex.hasMatch(name)) {
      return invalidNameMessage;
    }
    // if everything is good return null
    return null;
  }

  String get name {
    return this.textController.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: textController,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          border: OutlineInputBorder(),
        ),
        validator: _validateName);
  }
}
