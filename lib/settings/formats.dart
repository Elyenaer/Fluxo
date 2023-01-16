
import 'package:flutter/material.dart';

// ignore: camel_case_types
class formats{

  static Text standard(String text){
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        height: 1, 
        fontSize: 15,      
      ),
    );
  }

}