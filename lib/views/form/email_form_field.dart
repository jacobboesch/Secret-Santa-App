/* 
 * Used to enter and validate email input
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailFormField extends StatelessWidget {
  final String _emailPattern =
      r"^[a-zA-Z0-9!#$%&'*+\/=?^_`{|}~.-]{1,64}@[a-zA-Z0-9-.]+\.[a-zA-Z0-9-.]+";

  final String _errorMessage = "Error: invalid email";

  final String _label = "Email";

  final String _helperText = "*Required";

  final TextEditingController _textController = TextEditingController();

  final String _initialEmail;

  EmailFormField({Key key})
      : _initialEmail = null,
        super(key: key);

  EmailFormField.withInitialEmail(this._initialEmail);

  String _validateEmail(String email) {
    RegExp regex = RegExp(_emailPattern);

    if (!(regex.hasMatch(email))) {
      return _errorMessage;
    } else if (email.length > 320) {
      return _errorMessage;
    }
    // if email is valid return null
    return null;
  }

  String get email {
    return this._textController.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textController..text = _initialEmail,
      decoration: InputDecoration(
        labelText: _label,
        helperText: _helperText,
        border: OutlineInputBorder(),
      ),
      validator: _validateEmail,
      keyboardType: TextInputType.emailAddress,
    );
  }
}
