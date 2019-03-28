// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

/// [ConverterRoute] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatefulWidget {
  /// This [Category]'s name.
  final String name;

  /// Color for this [Category].
  final Color color;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterRoute] requires the name, color, and units to not be null.
  const ConverterRoute({
    @required this.name,
    @required this.color,
    @required this.units,
  })  : assert(name != null),
        assert(color != null),
        assert(units != null);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  //Set some variables, such as for keeping track of the user's input
  Unit _fromValue;
  Unit _toValue;
  List<DropdownMenuItem> _unitMenuItems;

  // TODO: Determine whether you need to override anything, such as initState()
  @override
  void initState() {
    _createDropDownMenuItem();
    _setDefault();
  }

  void _setDefault() {
    _fromValue = widget.units[0];
    _toValue = widget.units[1];
  }

  void _createDropDownMenuItem() {
    var newItems = <DropdownMenuItem>[];
    for (var unit in widget.units) {
      newItems.add(DropdownMenuItem(
          value: unit.name,
          child: Container(
            child: Text(
              unit.name,
              softWrap: true,
            ),
          )));
      setState(() {
        _unitMenuItems = newItems;
      });
    }
  }

  Widget _createDropdown(String currentValue) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(color: Colors.grey[400], width: 1.0)),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        //this is background of dropdown menu
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
            //hide underline
            child: ButtonTheme(
          //button theme for dropdown button
          alignedDropdown: true,
          child: DropdownButton(
              value: currentValue,
              items: _unitMenuItems,
              onChanged: (value) {
                print('click $value');
              }),
        )),
      ),
    );
  }

  // TODO: Add other helper functions. We've given you one, _format()
  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Create the 'input' group of widgets. This is a Column that
    // includes the input value, and 'from' unit [Dropdown].
    Widget inputWidget = Padding(
        padding: _padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              style: Theme.of(context).textTheme.headline,
              decoration: InputDecoration(
                labelText: 'Input',
                labelStyle: Theme.of(context).textTheme.headline,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
              onChanged: (value) {
                print("First text field: $value");
              },
            ),
            _createDropdown(_fromValue.name)
          ],
        ));

    //Create a compare arrows icon.
    final arrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    //Create the 'output' group of widgets. This is a Column that
    Widget outputWidget = Padding(
        padding: _padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InputDecorator(
              child: Text(
                "",
                style: Theme.of(context).textTheme.display1,
              ),
              decoration: InputDecoration(
                  labelText: 'Output',
                  labelStyle: Theme.of(context).textTheme.display1,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )),
            ),
            _createDropdown(_toValue.name),
          ],
        ));

    //Return the input, arrows, and output widgets, wrapped in a Column.
    Padding convertWidget = Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          inputWidget,
          arrows,
          outputWidget,
        ],
      ),
    );

    //Return the input, arrows, and output widgets, wrapped in a Column.
    return convertWidget;
  }
}
