
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CustomCreditDebt extends StatefulWidget{
  CustomCreditDebt({
    Key? key,
    required this.isCredit,
    required this.onToggle
  }) : super(key: key);

  bool isCredit;
  Function(bool) onToggle;

   @override
  // ignore: no_logic_in_create_state
  _MyHomePageState createState() => _MyHomePageState();
}

  // ignore: non_constant_identifier_names
  class _MyHomePageState extends State<CustomCreditDebt> {

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: 180.0,
      height: 50.0,
      valueFontSize: 25.0,
      toggleSize: 45.0,
      value: widget.isCredit,
      borderRadius: 30.0,
      padding: 8.0,
      activeText: "Crédito",
      inactiveText: "Débito",
      activeColor: Colors.green,
      inactiveColor: Colors.red,
      showOnOff: true,
      onToggle: (value) {
        setState(() {
          widget.isCredit = value;
          widget.onToggle(value);
        });        
      },
    );
  }
}