// ignore_for_file: file_names
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget{
  CustomTextField({
    Key? key,
    required this.controller,
    this.label,
    this.icon,
    this.enabled,
    this.maxLines
    }) : super(key: key);

  TextEditingController controller;
  String? label;
  IconData? icon;
  bool? enabled;
  int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines ??= 1,
      controller: controller,
      decoration: InputDecoration(
        enabled: enabled ??= true,
        border: const OutlineInputBorder(),
        icon: Icon(
          icon ??= Icons.text_fields
        ),
        labelText: label ??= '',
      ),
    );
  }

}
