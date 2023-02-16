// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:firebase_write/help/valid.dart';
import 'package:firebase_write/help/mask.dart';

// ignore: must_be_immutable
class CustomDateTextField extends StatelessWidget{
  CustomDateTextField({    
    Key? key,
    required this.controller,
    this.label,
    this.function,
  }) : super(key: key);

  TextEditingController controller;
  String? label;
  Function()? function;
  String? _error;  

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        mask.maskDate,
      ],
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        icon: const Icon(Icons.calendar_today_rounded),
        errorText: _error,
        labelText: label ??= "Data"
      ),
      onTap: () async {
        DateTime? pickeddate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100)
        );          
        if (pickeddate != null) {
            controller.text = DateFormat('dd/MM/yyyy').format(pickeddate);
            function!();
        }
      },
      onChanged: (value) {
          _error = valid.checkDate(controller.text);  
      },
    );
  }
}