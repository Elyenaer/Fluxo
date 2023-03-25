
import 'dart:convert';

import 'package:firebase_write/models/client/client_register.dart';
import 'package:firebase_write/settings/manager_access/api/api_request.dart';
import 'package:firebase_write/settings/manager_access/api/db_settings_api.dart';
import 'package:flutter/material.dart';

class ClientConnect {
  static const String _table = "client";

  Map<String, String> _convertData(ClientRegister reg){    
  
  return <String, String>{
      'name': reg.name.toString(),
      'type': reg.type.toString(),
    };
}

  ClientRegister? _convertRegister(Map<String, dynamic> data){
    try{
      ClientRegister reg = ClientRegister(
        data['client_id'],
        data['name'],
        data['type']
      );
      return reg;
    }catch(e){
      debugPrint("CLIENTREGISTER ERRO _CONVERTREGISTER $e");
      return null;
    }
}

Future<int> setData(ClientRegister register) async {
  try{
    var response = await ApiRequest.setData(_table,_convertData(register));
    return response[1];
  }catch(e){
    debugPrint("CLIENTCONNECT SETDATA -> $e");
    return 0;
  }
  
}

Future<ClientRegister?> getById(int id) async {
  try {
    ClientRegister? register;

    var res = await ApiRequest.getById(_table, id);
    var data = json.decode(res.body);

    for(var item in data){
      register = _convertRegister(item);
    }

    return register;
  }catch(e){
    debugPrint("CLIENTCONNECT ERRO GETBYID -> $e");
    return null;
  }
}

Future<ClientRegister?> getByName(String name) async {
  try {
    ClientRegister? register;

    var res = await ApiRequest.getCustom(
        " SELECT * FROM ${DBsettingsApi.dbName}$_table WHERE name = '$name' "
      );
    var data = json.decode(res.body);

    for(var item in data){
      register = _convertRegister(item);
    }

    return register;
  }catch(e){
    debugPrint("CLIENTCONNECT ERRO GETBYID -> $e");
    return null;
  }
}


}