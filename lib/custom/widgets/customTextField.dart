
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget{
  CustomTextField({
    Key? key,
    required this.controller,
    this.label,
    this.icon,
    this.enabled
    }) : super(key: key);

  TextEditingController controller;
  String? label;
  IconData? icon;
  bool? enabled;

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

  // ignore: non_constant_identifier_names
  class _MyHomePageState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        enabled: widget.enabled ??= true,
        border: const OutlineInputBorder(),
        icon: Icon(
          widget.icon ??= Icons.text_fields
        ),
        labelText: widget.label ??= '',
      ),
    );
  }

}
