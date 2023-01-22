

import 'package:firebase_write/database.dart/connection/themeConnect.dart';
import 'package:firebase_write/database.dart/register/themeRegister.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class theme{

 late ThemeRegister register;

 _getTheme() async {
    try{
      register = (await ThemeConnect().getId(1))!;
    }catch(e){
      print("ERRO _GETTHEME -> $e");
    }
  }

  Future<ThemeData> current() async {
    try{
      await _getTheme();
      return ThemeData(

        appBarTheme: AppBarTheme(
          backgroundColor: register.backgroundTitle,
          foregroundColor: register.foregroundTitle
        ),

        buttonTheme: ButtonThemeData(
          buttonColor: register.widgetPrimaryColor, 
          textTheme: ButtonTextTheme.primary, 
        ),

        sliderTheme: SliderThemeData(
          thumbColor: register.widgetPrimaryColor,
          overlayColor: register.widgetSecondaryColor,
          valueIndicatorColor: register.widgetSecondaryColor,
          inactiveTrackColor: register.widgetSecondaryColor,
          inactiveTickMarkColor: register.widgetSecondaryColor,
          activeTrackColor: register.widgetPrimaryColor,
          activeTickMarkColor: register.widgetPrimaryColor,

        ),

        scaffoldBackgroundColor: register.backgroundMain,
        primaryColor: register.backgroundTitle,
      );
    }catch(e){
      print("ERRO CURRENT -> $e");
      return ThemeData.dark();
    }
  }

}

