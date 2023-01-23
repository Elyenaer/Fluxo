
import 'package:flutter/material.dart';

// ignore: camel_case_types
class formats{

  static Text standard(String text,Color foreground){
    return Text(
      text,
      style: TextStyle(
        color: foreground,
        height: 1, 
        fontSize: 15,      
      ),
    );
  }

}