

import 'package:firebase_write/database.dart/connection/themeConnect.dart';
import 'package:firebase_write/database.dart/register/themeRegister.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class theme{

  late ThemeRegister register;

  static Color backgroundTitleDebt1 = const Color.fromARGB(255, 130, 0, 0);
  static Color backgroundTitleDebt2 = const Color.fromARGB(255, 100, 0, 0);
  static Color backgroundTitleCredit1 = const Color.fromARGB(255, 0, 0,130);
  static Color backgroundTitleCredit2 = const Color.fromARGB(255, 0, 0, 100);

  static Color backgroundEntryDebt1 = const Color.fromARGB(255, 255, 242, 242);
  static Color backgroundEntryDebt2 = const Color.fromARGB(255, 255, 220, 220);
  static Color backgroundEntryCredit1 = const Color.fromARGB(255, 242, 242, 255);
  static Color backgroundEntryCredit2 = const Color.fromARGB(255, 220, 220, 255);

  static Color foregroundEntryCredit = Colors.blue;
  static Color foregroundEntryDebt = Colors.red;
      
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

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: register.widgetPrimaryColor, 
          foregroundColor: register.foregroundTitle,
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

        inputDecorationTheme: InputDecorationTheme(
          iconColor: register.widgetSecondaryColor,
          labelStyle: TextStyle(
            color: register.widgetPrimaryColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: register.widgetSecondaryColor            
            )
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: register.widgetPrimaryColor              
            )
          ),
        ),

        colorScheme: ColorScheme(
            primary: register.widgetPrimaryColor,
            onPrimary: register.widgetForeground, 
            onSurface: register.widgetTextColor,

            /*
            primaryContainer: Colors.yellow,
            secondaryContainer: Colors.yellow,
            onSecondaryContainer: Colors.yellow,
            onSurfaceVariant: Colors.yellow,
            onPrimaryContainer: Colors.yellow,
            surfaceTint: Colors.yellow,
            surfaceVariant: Colors.yellow,
            inverseSurface: Colors.yellow,
            inversePrimary: Colors.yellow,
            onInverseSurface: Colors.yellow,
            onTertiary: Colors.yellow,
            tertiaryContainer: Colors.yellow,
            onTertiaryContainer: Colors.yellow,
            tertiary: Colors.yellow,
            outline: Colors.yellow,
            shadow: Colors.yellow,
            errorContainer: Colors.yellow,
            onErrorContainer: Colors.yellow,*/            

            background: Colors.yellow, 
            brightness: Brightness.light, 
            error: Colors.yellow, 
            onBackground: Colors.yellow,
            onError: Colors.yellow,
            onSecondary: Colors.yellow,
            surface: Colors.yellow,
            secondary: Colors.yellow,
        ),

        textTheme: TextTheme(
          subtitle1: TextStyle(
            color: register.widgetTextColor,
          )
        ),

        scaffoldBackgroundColor: register.backgroundMain,
        primaryColor: register.widgetPrimaryColor,
      );
    }catch(e){
      print("ERRO CURRENT -> $e");
      return ThemeData.light();
    }
  }

}

