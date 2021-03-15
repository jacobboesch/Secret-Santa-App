/*
* Dropdown menu of household objects 
*/
import 'dart:collection';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HouseholdDropdown extends StatefulWidget {
  final List<String> _households;
  final String _initialHousehold;
  _HouseholdDropdownState _state;

  HouseholdDropdown(this._households, {Key key})
      : _initialHousehold = _households[0],
        super(key: key);

  HouseholdDropdown.withInitialHousehold(
      this._households, this._initialHousehold);

  @override
  _HouseholdDropdownState createState() {
    this._state = new _HouseholdDropdownState(_initialHousehold);
    return this._state;
  }

  String get selectedHousehold {
    return this._state._selectedHousehold;
  }
}

class _HouseholdDropdownState extends State<HouseholdDropdown> {
  String _selectedHousehold;

  _HouseholdDropdownState(this._selectedHousehold);

  List<DropdownMenuItem> _dropdownItems = [];

  @override
  void initState() {
    super.initState();
    // add dropdown items to the list
    for (String household in widget._households) {
      _dropdownItems
          .add(new DropdownMenuItem(value: household, child: Text(household)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: _selectedHousehold,
      items: _dropdownItems,
      decoration: InputDecoration(
        labelText: "Household",
        border: OutlineInputBorder(),
      ),
      // update the selected household when dropdown changes
      onChanged: (value) {
        setState(() {
          _selectedHousehold = value;
        });
      },
    );
  }
}
