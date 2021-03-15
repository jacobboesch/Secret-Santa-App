/*
* Dropdown menu of household objects 
*/
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:secret_santa_app/models/household.dart';

class HouseholdDropdown extends StatefulWidget {
  // TODO replace with real list of households
  final List<Household> _households;
  _HouseholdDropdownState _state;
  HouseholdDropdown(this._households, {Key key}) : super(key: key);

  @override
  _HouseholdDropdownState createState() {
    this._state = new _HouseholdDropdownState();
    return this._state;
  }

  Household get selectedHousehold {
    return this._state._selectedHousehold;
  }
}

class _HouseholdDropdownState extends State<HouseholdDropdown> {
  Household _selectedHousehold;

  List<DropdownMenuItem> _dropdownItems = [];

  @override
  void initState() {
    super.initState();
    this._selectedHousehold = widget._households[0];
    // add dropdown items to the list
    for (Household household in widget._households) {
      _dropdownItems.add(new DropdownMenuItem(
          value: household, child: Text(household.household)));
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
