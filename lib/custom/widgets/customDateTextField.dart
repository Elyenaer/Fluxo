import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:firebase_write/help/valid.dart';
import 'package:firebase_write/help/mask.dart';

// ignore: must_be_immutable
class CustomDateTextField extends StatefulWidget{
  CustomDateTextField({    
    Key? key,
    required this.controller,
    this.label,
    this.function,
  }) : super(key: key);

  TextEditingController controller;
  String? label;
  Function()? function;

   @override
  // ignore: no_logic_in_create_state
  _MyHomePageState createState() => _MyHomePageState();
}

  // ignore: non_constant_identifier_names
  class _MyHomePageState extends State<CustomDateTextField> {
    String? _error;   

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        mask.maskDate,
      ],
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        icon: const Icon(Icons.calendar_today_rounded),
        errorText: _error,
        labelText: widget.label ??= "Data"
      ),
      onTap: () async {
        DateTime? pickeddate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100)
        );          
        if (pickeddate != null) {
          setState(() {
            widget.controller.text = DateFormat('dd/MM/yyyy').format(pickeddate);
            widget.function!();
          });
        }
      },
      onChanged: (value) {
        setState(() {
          _error = valid.checkDate(widget.controller.text);
          widget.function!();
        });          
      },
    );
  }
}