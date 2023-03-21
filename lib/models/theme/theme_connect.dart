// ignore_for_file: file_names
import 'package:firebase_write/help/funcColor.dart';
import 'package:firebase_write/help/funcNumber.dart';
import 'package:firebase_write/settings/manager_access/firebase/db_settings.dart';
import 'package:flutter/material.dart';

import 'theme_register.dart';

// ignore: camel_case_types
class ThemeConnect {

  final String collection = "theme";

  Map<String, String> _convertData(ThemeRegister reg){
    return <String, String>{
      'id': funcNumber.includeZero(reg.id,4),
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

  ThemeRegister? _convertRegister(Map<String, dynamic> data){
    try{
      ThemeRegister register = ThemeRegister();

      register.id = int.parse(data['id']);
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
      debugPrint("ERRO _CONVERTREGISTER $e");
      return null;
    }
}

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
  }

  Future<Map<String, String>?> get(int id) async {
    try {

      // to get data from all documents sequentially      
      await DBsettings.getDbCollection(collection)
      .where('id', isGreaterThanOrEqualTo: id)    
      .get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          return result.data();
        }
      });

      return null;
    }catch(e){
      debugPrint("ERRO GETDATA -> $e");
      return null;
    }
  }

  Future<void> setData(ThemeRegister register) async {
    await DBsettings.getDbCollection(collection).doc(register.id.toString()).set(_convertData(register)).catchError((error)
      => debugPrint("Failed to add user: $error"));
  }

  Future<bool> createCollection() async {
    bool success = false;
    try{
      await DBsettings.getDbCollection(collection).add({
        "key": collection 
      }).then((_){
        success = true;
      });
    }catch(e){
      debugPrint("ERRO -> $e");      
    }finally{
      // ignore: control_flow_in_finally
      return success;
    }    
  }

}





