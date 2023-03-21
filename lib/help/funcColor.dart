// ignore_for_file: file_names
import 'package:flutter/material.dart';

// ignore: camel_case_types
class funcColor{

  static Color getColorByHex(String hex){
    return Color(int.parse("0x"+hex));
  }

  static String getHexByColor(Color color){
    return color.value.toRadixString(16).substring(2).toUpperCase();
  }


}