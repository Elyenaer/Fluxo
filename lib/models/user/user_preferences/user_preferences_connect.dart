
import 'dart:convert';

import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/models/user/user_preferences/user_preferences_register.dart';
import 'package:flutter/material.dart';

import '../../../settings/manager_access/api/api_request.dart';

class UserPreferencesConnect {

  final _table = "user_preferences";

  UserPreferencesRegister? _convertRegister(Map<String, dynamic> data){
    try{
      UserPreferencesRegister register = UserPreferencesRegister(
        data['user_preferences_id'],
        data['theme_id'],
        double.parse(data['scale']),
        data['period_report'],
        convert.DatabaseToDatetime(data['start_date_report']),
        convert.DatabaseToDatetime(data['end_date_report'])    
      );

      return register;
    }catch(e){
      debugPrint("ERRO USERPREFERENCESCONNECT _CONVERTREGISTER $e");
      return null;
    }
}

  Map<String, String> _convertData(UserPreferencesRegister register){
    return <String, String>{
      'id_user': register.id_user_preferences!.toString(),
      'start_date_report': convert.DatetimeToDatabase(register.start_date_report!),
      'end_date_report': convert.DatetimeToDatabase(register.end_date_report!),
      'scale': register.scale.toString(),
      'id_theme': register.id_theme.toString(),
      'period_report': register.period_report!
    };
  }

  Future<UserPreferencesRegister?> getById(int idUser) async {
     try {
      UserPreferencesRegister? registers;

      var res = await ApiRequest.getById(_table,idUser);
      var data = json.decode(res.body);

      for(var item in data){
        registers = _convertRegister(item);
      }

      return registers;
    }catch(e){
      debugPrint("USERPREFERENCECONNECT ERRO GETDATA -> $e");
      return null;
    }
  }

  Future<void> update(UserPreferencesRegister register) async {
    await ApiRequest.update(_table,_convertData(register), register.id_user_preferences);
  }


}




