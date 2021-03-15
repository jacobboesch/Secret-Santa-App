/*
* This screen allows the user to define a new household
*/
import 'package:flutter/material.dart';
import 'package:secret_santa_app/views/form/house_hold_dropdown.dart';
import 'package:secret_santa_app/views/layout/one_column_layout.dart';

class HouseholdScreen extends StatelessWidget {
  final String _emptyErrorMessage = "Error: household can't be empty";
  final TextEditingController _textController = TextEditingController();
  final String _label = "Household";
  final String _helperText = "*Required";

  final bool _editEnabled;
  final String _initialHousehold;

  final String _deleteConfirmationTitle = "Delete household?";
  final String _deleteConfirmationHelperText =
      "The household will be permanently removed from the list of households";
  final String _deleteConfirmationCancelText = "CANCEL";
  final String _deleteConfirmationConfirmText = "DELETE";

  HouseholdScreen({Key key})
      : _editEnabled = false,
        _initialHousehold = null,
        super(key: key);

  HouseholdScreen.withHousehold(this._initialHousehold) : _editEnabled = true;

  // validator for the household
  String _validateHouseHold(String household) {
    if (household.isEmpty) {
      return _emptyErrorMessage;
    }
    return null;
  }

  // called when the delete button is pressed
  // TODO could possibly replace this with it's own class
  // and lambda function
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
                          // TODO replace this with delete function
                          Navigator.pop(context)
                        },
                    child: Text(_deleteConfirmationConfirmText))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Household"),
          actions: _editEnabled
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
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Household field
              OneColumnLayout(TextFormField(
                controller: _textController..text = _initialHousehold,
                decoration: InputDecoration(
                    labelText: _label,
                    helperText: _helperText,
                    border: OutlineInputBorder()),
                validator: _validateHouseHold,
              ))
            ],
          ),
        ));
  }
}
