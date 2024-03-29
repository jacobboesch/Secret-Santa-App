/*
* This screen allows the user to define a new household
*/
import 'package:flutter/material.dart';
import 'package:secret_santa_app/models/household.dart';
import 'package:secret_santa_app/services/household_service.dart';
import 'package:secret_santa_app/views/layout/one_column_layout.dart';
import 'package:sqflite/sqflite.dart';

class HouseholdScreen extends StatelessWidget {
  final String _emptyErrorMessage = "Error: group name can't be empty";
  final TextEditingController _textController = TextEditingController();
  final String _label = "Group Name";
  // TODO add helper group
  final String _helperText = "*Required";

  final bool _editEnabled;
  final Household _household;

  final String _deleteConfirmationTitle = "Delete group?";
  final String _deleteConfirmationHelperText =
      "The group will be permanently removed from the list of groups, Along with any participants that belong to this group.";
  final String _deleteConfirmationCancelText = "CANCEL";
  final String _deleteConfirmationConfirmText = "DELETE";
  final HouseholdService householdService = HouseholdService();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  HouseholdScreen({Key key})
      : _editEnabled = false,
        _household = Household(null, ""),
        super(key: key);

  HouseholdScreen.withHousehold(this._household) : _editEnabled = true;

  // validator for the household
  String _validateHouseHold(String household) {
    if (household.isEmpty) {
      return _emptyErrorMessage;
    }
    return null;
  }

  void _saveHousehold(BuildContext context) async {
    if (_key.currentState.validate()) {
      _household.household = _textController.text;
      try {
        if (_household.id != null) {
          await householdService.update(_household);
        } else {
          await householdService.create(_household);
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Group saved")));
      } on DatabaseException catch (e) {
        // if the error is that a unqiue contraint is voilated then
        // we know that for this table it's becuase there's already a household
        // with the same name
        if (e.getResultCode() == 2067) {
          // Since the household already exists we'll just inform the user
          // that the household is saved. No need for an error message
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Group saved")));
        } else {
          _displayUnexpectedErrorMessage(context);
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Unexpected Error Saving Group")));
      }
      Navigator.pop(context);
    }
  }

  void _deleteHousehold(BuildContext context) async {
    try {
      await householdService.delete(_household);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Group Deleted")));
    } catch (e) {
      _displayUnexpectedErrorMessage(context);
    }
    // Pop to get out of dialog
    Navigator.pop(context);
    // Pop again to get back to home screen
    Navigator.pop(context);
  }

  void _displayUnexpectedErrorMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected Error Deleting Group")));
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
                    onPressed: () => {_deleteHousehold(context)},
                    child: Text(_deleteConfirmationConfirmText))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Group"),
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
        key: _key,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Household field
            OneColumnLayout(TextFormField(
              controller: _textController..text = _household.household,
              decoration: InputDecoration(
                  labelText: _label,
                  helperText: _helperText,
                  border: OutlineInputBorder()),
              validator: _validateHouseHold,
            ))
          ],
        ),
      ),
      bottomSheet: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton.icon(
                onPressed: () {
                  _saveHousehold(context);
                },
                icon: Icon(Icons.save),
                label: Text("SAVE")),
          )
        ],
      ),
    );
  }
}
