// ignore_for_file: file_names
import 'package:firebase_write/help/funcColor.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class ThemeRegister{

  late int id;
  late String name;

  late Color backgroundMain;
  late Color backgroundTitle;

  late Color foregroundMain;
  late Color foregroundTitle;

  late Color widgetPrimaryColor;
  late Color widgetSecondaryColor;
  late Color widgetForeground;
  late Color widgetTextColor;
  late Color widgetContainer;

  setBackgrounMain(String hex){
    backgroundMain = funcColor.getColorByHex(hex);
  }

  setBackgrounTitle(String hex){
    backgroundTitle = funcColor.getColorByHex(hex);
  }

  setForegroundMain(String hex){
    foregroundMain = funcColor.getColorByHex(hex);
  }

  setForegroundTitle(String hex){
    foregroundTitle = funcColor.getColorByHex(hex);
  }

  setWidgetPrimaryColor(String hex){
    widgetPrimaryColor = funcColor.getColorByHex(hex);
  }

  setWidgetSecondaryColor(String hex){
    widgetSecondaryColor = funcColor.getColorByHex(hex);
  }

  setWidgetForeground(String hex){
    widgetForeground = funcColor.getColorByHex(hex);
  }

  setWidgetTextColor(String hex){
    widgetTextColor = funcColor.getColorByHex(hex);
  }

  setWidgetContainer(String hex){
    widgetContainer = funcColor.getColorByHex(hex);
  }


}