/* 
 * Used to enter and validate email input
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailFormField extends StatelessWidget {
  final String _emailPattern =
      r"^[a-z0-9!#$%&'*+\/=?^_`{|}~.-]{1,64}@[a-zA-Z0-9-.]{1,255}";

  final String _errorMessage = "Error: invalid email";

  final String _label = "Email";

  final String _helperText = "*Required";

  final TextEditingController _textController = TextEditingController();

  EmailFormField({Key key}) : super(key: key);

  String _validateEmail(String email) {
    RegExp regex = RegExp(_emailPattern);

    if (!regex.hasMatch(email)) {
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
      controller: _textController,
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
