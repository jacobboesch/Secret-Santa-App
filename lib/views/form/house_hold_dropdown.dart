/*
* Dropdown menu of household objects
*/
import 'package:flutter/material.dart';
import 'package:secret_santa_app/models/household.dart';

// ignore: must_be_immutable
class HouseholdDropdown extends StatefulWidget {
  List<String> _households;
  String _initialHousehold;
  _HouseholdDropdownState _state;

  HouseholdDropdown() {
    _households = [];
    _initialHousehold = null;
  }

  HouseholdDropdown.withInitialHousehold(this._initialHousehold) {
    _households = [];
  }

  @override
  _HouseholdDropdownState createState() {
    this._state = new _HouseholdDropdownState(_initialHousehold);
    return this._state;
  }

  String get selectedHousehold {
    return this._state._selectedHousehold;
  }

  set households(List<Household> households) {
    _households = households.map<String>((e) => e.household).toList();
    if (this._state != null) {
      this._state.updateDropdownItems();
    }
  }
}

class _HouseholdDropdownState extends State<HouseholdDropdown> {
  String _selectedHousehold;

  _HouseholdDropdownState(this._selectedHousehold);

  List<DropdownMenuItem> _dropdownItems = [];

  @override
  void initState() {
    super.initState();
    updateDropdownItems();
  }

  void updateDropdownItems() {
    // add dropdown items to the list
    _dropdownItems.clear();
    for (String household in widget._households) {
      _dropdownItems
          .add(new DropdownMenuItem(value: household, child: Text(household)));
    }
    setState(() {});
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
