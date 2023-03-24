
import 'dart:convert';

import 'package:firebase_write/models/user/user/user_register.dart';
import 'package:firebase_write/models/user/user_credential/user_credential_register.dart';
import 'package:firebase_write/settings/manager_access/api/api_request.dart';
import 'package:firebase_write/settings/manager_access/api/db_settings_api.dart';
import 'package:flutter/material.dart';

class UserConnect {

  final String _table = "user";

  Map<String, String> _convertData(UserRegister reg){   
    return <String, String>{
      'user_id': reg.id.toString(), 
      'name': reg.name!,  
      'email': reg.email!,
    };
  }

  UserRegister? _convertRegister(Map<String, dynamic> data){
    try{
      UserRegister reg = UserRegister(
        data['user_id'],
        data['name'],
        data['email']
      );

      return reg;
    }catch(e){
      debugPrint("USERREGISTER ERRO _CONVERTREGISTER $e");
      return null;
    }
}

  Future<void> setData(UserRegister register) async {
    await ApiRequest.setData(_table,_convertData(register));
  }

  Future<List<UserRegister>?> getData() async {
    try {
      List<UserRegister> registers = [];

      var res = await ApiRequest.getAllByClient(_table);
      var data = json.decode(res.body);

      for(var item in data){
        UserRegister? r = _convertRegister(item);
        registers.add(r!);
      }

      return registers;
    }catch(e){
      debugPrint("USERREGISTER ERRO GETDATA -> $e");
      return null;
    }
  }

  Future<UserRegister?> getUserByCredential(UserCredentialRegister userCredential) async {
    try {
      UserRegister? register;

      var res = await ApiRequest.getCustom(
        " SELECT * FROM ${DBsettingsApi.dbName}$_table WHERE email = '${userCredential.email}' "
      );
      var data = json.decode(res.body);

      for(var item in data){
        register = _convertRegister(item);
      }

      return register;
    }catch(e){
      debugPrint("USERREGISTER ERRO GETUSERBYCREDENTIAL -> $e");
      return null;
    }
  }

  Future<void> update(UserRegister register) async {
    await ApiRequest.update(_table,_convertData(register), register.id);
  }

  Future<bool> delete(UserRegister register) async {
    return await ApiRequest.delete(_table,register.id);
  }

}