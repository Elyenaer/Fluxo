// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/material.dart';

import '../../settings/manager_access/api/api_request.dart';
import 'theme_register.dart';

// ignore: camel_case_types
class ThemeConnect {

  final _table = "theme";

  /*
  Map<String, String> _convertData(ThemeRegister reg){
    return <String, String>{
      'id': reg.id.toString(),
      'name': reg.name,    
      'bakcgroundMain': funcColor.getHexByColor(reg.backgroundMain),   
      'bakcgroundTitle': funcColor.getHexByColor(reg.backgroundTitle),   
      'foregroundMain': funcColor.getHexByColor(reg.foregroundMain),   
      'foregroundTitle': funcColor.getHexByColor(reg.foregroundTitle),   
      'widgetContainer': funcColor.getHexByColor(reg.widgetContainer),   
      'widgetForeground': funcColor.getHexByColor(reg.widgetForeground),   
      'widgetPrimaryColor': funcColor.getHexByColor(reg.widgetPrimaryColor),   
      'widgetSecondaryColor': funcColor.getHexByColor(reg.widgetSecondaryColor),   
      'widgetTextColor': funcColor.getHexByColor(reg.widgetTextColor),   
    }; 
  }
  */

  ThemeRegister? _convertRegister(Map<String, dynamic> data){
    try{
      ThemeRegister register = ThemeRegister();

      register.id = data['theme_id'];
      register.name = data['name'];

      register.setBackgrounMain(data['backgroundMain']);
      register.setBackgrounTitle(data['backgroundTitle']);

      register.setForegroundMain(data['foregroundMain']);
      register.setForegroundTitle(data['foregroundTitle']);

      register.setWidgetPrimaryColor(data['widgetPrimaryColor']);
      register.setWidgetSecondaryColor(data['widgetSecondaryColor']);
      register.setWidgetForeground(data['widgetForeground']);
      register.setWidgetTextColor(data['widgetTextColor']);
      register.setWidgetContainer(data['widgetContainer']);

      return register;
    }catch(e){
      debugPrint("THEME ERRO _CONVERTREGISTER $e");
      return null;
    }
}

/*
  Future<ThemeRegister?> getId(int id) async {
    try {
      ThemeRegister? register;

      // to get data from all documents sequentially      
      await DBsettings.getDbCollection(collection)
      .where('id', isEqualTo: funcNumber.includeZero(id,4))    
      .get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          register = _convertRegister(result.data() as Map<String,dynamic>) as ThemeRegister;
        }
      });

      return register;
    }catch(e){
      debugPrint("ERRO GETID -> $e");
      return null;
    }
  }*/

  Future<ThemeRegister?> getDataById(int id) async {
    try {
      ThemeRegister? registers;

      var res = await ApiRequest.getById(_table,id);
      var data = json.decode(res.body);

      for(var item in data){
        registers = _convertRegister(item);
      }

      return registers;
    }catch(e){
      debugPrint("THEMEREGISTER ERRO GETDATABYID -> $e");
      return null;
    }
  }

/*
  Future<void> setData(ThemeRegister register) async {
    await DBsettings.getDbCollection(collection).doc(register.id.toString()).set(_convertData(register)).catchError((error)
      => debugPrint("Failed to add user: $error"));
  }*/

}





