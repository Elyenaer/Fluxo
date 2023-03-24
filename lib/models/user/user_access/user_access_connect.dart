
import 'dart:convert';

import 'package:firebase_write/models/user/user_access/user_access_register.dart';
import 'package:firebase_write/settings/manager_access/api/api_request.dart';
import 'package:firebase_write/settings/manager_access/api/db_settings_api.dart';
import 'package:flutter/material.dart';

class UserAccessConnect {
  final String _table = "user_access";

  Map<String, String> _convertData(UserAccessRegister reg){   
    return <String, String>{
      'user_access_id': reg.id.toString(), 
      'user_id': reg.userId!.toString(),  
      'user_preferences_id': reg.userPreferencesId!.toString(),
      'client_id': reg.clientId!.toString(),
    };
  }

  UserAccessRegister? _convertRegister(Map<String, dynamic> data){
    try{
      UserAccessRegister reg = UserAccessRegister();

      reg.id = data['user_access_id'];
      reg.userId = data['user_id'];
      reg.userPreferencesId = data['user_preferences_id'];
      reg.clientId = data['client_id'];

      return reg;
    }catch(e){
      debugPrint("USERACCESSREGISTER ERRO _CONVERTREGISTER $e");
      return null;
    }
}

  Future<void> setData(UserAccessRegister register) async {
    await ApiRequest.setData(_table,_convertData(register));
  }

  Future<List<UserAccessRegister>?> getData() async {
    try {
      List<UserAccessRegister> registers = [];

      var res = await ApiRequest.getAllByClient(_table);
      var data = json.decode(res.body);

      for(var item in data){
        UserAccessRegister? r = _convertRegister(item);
        registers.add(r!);
      }

      return registers;
    }catch(e){
      debugPrint("USERACCESSREGISTER ERRO GETDATA -> $e");
      return null;
    }
  }

  Future<List<UserAccessRegister>?> getDataByUser(int userId) async {
    try {
      List<UserAccessRegister> registers = [];

      var res = await ApiRequest.getCustom(
        " SELECT * FROM ${DBsettingsApi.dbName}$_table WHERE user_id = '$userId' "
      );
      var data = json.decode(res.body);

      for(var item in data){
        UserAccessRegister? r = _convertRegister(item);
        registers.add(r!);
      }

      return registers;
    }catch(e){
      debugPrint("USERACCESSREGISTER ERRO GETDATABYUSER -> $e");
      return null;
    }
  }

  Future<void> update(UserAccessRegister register) async {
    await ApiRequest.update(_table,_convertData(register), register.id);
  }

  Future<bool> delete(UserAccessRegister register) async {
    return await ApiRequest.delete(_table,register.id);
  }

}