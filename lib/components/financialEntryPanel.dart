// ignore: file_names
import 'package:firebase_write/register/financialEntryRegister.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types, must_be_immutable
class financialEntryPanel extends StatefulWidget{
  late FinancialEntryRegister register;
  
  // ignore: use_key_in_widget_constructors
  financialEntryPanel(
    {
      Key? key,
      required this.register
    } 
  );

  // ignore: no_logic_in_create_state
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<financialEntryPanel> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.amberAccent,
      ),
    );
  }

}