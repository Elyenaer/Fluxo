import 'package:firebase_write/models/theme/theme_connect.dart';
import 'package:firebase_write/models/theme/theme_register.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class ThemeController with ChangeNotifier{

  static ThemeData theme = ThemeData.dark();
  late ThemeRegister register;

  static Color backgroundEntryDebt1 = const Color.fromARGB(255, 255, 242, 242);
  static Color backgroundEntryDebt2 = const Color.fromARGB(255, 255, 220, 220);
  static Color backgroundEntryCredit1 = const Color.fromARGB(255, 242, 242, 255);
  static Color backgroundEntryCredit2 = const Color.fromARGB(255, 220, 220, 255);
/*
  static Color backgroundTitleDebt1 = const Color.fromARGB(255, 255, 210, 210);
  static Color backgroundTitleDebt2 = const Color.fromARGB(255, 255, 190, 190);
  static Color backgroundTitleCredit1 = const Color.fromARGB(255, 210, 210, 255);
  static Color backgroundTitleCredit2 = const Color.fromARGB(255, 190, 190, 255);*/
  
  static Color backgroundTitleDebt1 = backgroundEntryDebt1;
  static Color backgroundTitleDebt2 = backgroundEntryDebt2;
  static Color backgroundTitleCredit1 = backgroundEntryCredit1;
  static Color backgroundTitleCredit2 = backgroundEntryCredit2;

  static Color backgroundBalanceCredit = const Color.fromARGB(255, 70, 70, 255);
  static Color backgroundBalanceDebt = const Color.fromARGB(255, 255, 0, 0);

  static Color foregroundEntryCredit = Colors.blue;
  static Color foregroundEntryDebt = Colors.red;

  static Color foregroundTitleCredit = const Color.fromARGB(255, 0, 0, 180);
  static Color foregroundTitleDebt = const Color.fromARGB(255, 180, 0, 0);

  static IconData debtIcon = Icons.attach_money;
  static IconData creditIcon = Icons.money_off;

      
 _getTheme(int idTheme) async {
    try{
      register = (await ThemeConnect().getId(idTheme))!;
    }catch(e){
      debugPrint("ERRO _GETTHEME -> $e");
    }
  }

  getTheme() async {
    await current();
    return theme;
  }

  current() async {
    try{
      await _getTheme(1);
      theme = ThemeData(

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

          background: register.backgroundMain, 
          brightness: Brightness.light, 
          error: Colors.yellow, 
          onBackground: register.widgetContainer,
          onError: Colors.yellow,
          onSecondary: Colors.yellow,
          surface: Colors.yellow,
          secondary: register.widgetSecondaryColor,
        ),

        textTheme: TextTheme(
          subtitle1: TextStyle(
            color: register.widgetTextColor,
          )
        ),

        scaffoldBackgroundColor: register.backgroundMain,
        backgroundColor: register.widgetSecondaryColor,
        primaryColor: register.widgetPrimaryColor,
      );
      notifyListeners();
    }catch(e){
      debugPrint("ERRO CURRENT -> $e");
    }
  }

}

