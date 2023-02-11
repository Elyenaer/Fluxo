
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Help/currencyPtBrInputFormatter.dart';
import 'package:firebase_write/help/convert.dart';

class CustomCurrencytextField extends StatefulWidget{
  CustomCurrencytextField({
    Key? key,
    required this.controller,
    this.errorText,
  }) : super(key: key);

  TextEditingController controller;
  String? errorText;

   @override
  // ignore: no_logic_in_create_state
  _MyHomePageState createState() => _MyHomePageState();
}

  // ignore: non_constant_identifier_names
  class _MyHomePageState extends State<CustomCurrencytextField> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        icon: const Icon(Icons.monetization_on),
        labelText: 'Valor',
        errorText: widget.errorText,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CurrencyPtBrInputFormatter()
      ],
      onChanged: (value) {
        try {
          if (convert.currencyToDouble(value) == 0) {
            widget.errorText = 'Valor Inválido';
          } else {
            widget.errorText = null;
          }
        } catch (e) {
          widget.errorText = 'Valor Inválido';
        }
      },
    );
  }
}