
import 'package:firebase_write/help/funcColor.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class ThemeRegister{

  late int id;
  late String name;

  late Color backgroundMain;
  late  Color backgroundTitle;

  late Color foregroundMain;
  late Color foregroundTitle;

  late Color widgetPrimaryColor;
  late Color widgetSecondaryColor;
  late Color widgetForeground;

  setBackgrounMain(String hex){
    backgroundMain = funcColor.getHex(hex);
  }

  setBackgrounTitle(String hex){
    backgroundTitle = funcColor.getHex(hex);
  }

  setForegroundMain(String hex){
    foregroundMain = funcColor.getHex(hex);
  }

  setForegroundTitle(String hex){
    foregroundTitle = funcColor.getHex(hex);
  }

  setWidgetPrimaryColor(String hex){
    widgetPrimaryColor = funcColor.getHex(hex);
  }

  setWidgetSecondaryColor(String hex){
    widgetSecondaryColor = funcColor.getHex(hex);
  }

  setWidgetForeground(String hex){
    widgetForeground = funcColor.getHex(hex);
  }

}