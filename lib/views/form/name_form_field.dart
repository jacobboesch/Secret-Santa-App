/*
* Textfield for name input
* this class is responsible for validating the name input 
* and how the textbox is presented
*/
import 'package:flutter/material.dart';

class NameFormField extends StatelessWidget {
  // one to unlimited alphabetical and space characters
  final String namePattern = r"^[a-zA-Z ]+";
  // error message for empty name
  final String emptyErrorMessage = "Error: Name can't be empty";

  final String invalidNameMessage = "Error: Only alphabetical allowed";

  final String _label = "Name";

  final String _helperText = "*Required";

  final TextEditingController textController = TextEditingController();

  final String _initialName;

  NameFormField.withIntialName(this._initialName);

  NameFormField({Key key})
      : _initialName = null,
        super(key: key);

  String _validateName(String name) {
    RegExp regex = RegExp(namePattern);

    // first check if the name is empty
    if (name.isEmpty) {
      return emptyErrorMessage;
    } else if (!(regex.stringMatch(name) == name)) {
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
        controller: textController..text = _initialName,
        decoration: InputDecoration(
          labelText: _label,
          helperText: _helperText,
          border: OutlineInputBorder(),
        ),
        validator: _validateName);
  }
}
