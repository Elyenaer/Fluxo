
import 'dart:convert';
import 'package:firebase_write/models/account/account_register.dart';
import 'package:flutter/material.dart';

import '../../settings/manager_access/api/api_request.dart';

class AccountConnect {

  final String _table = "account";

  Map<String, String> _convertData(AccountRegister reg){
    
  //credit
    var c = 'D';
    if (reg.credit!){
      c = 'C';
    }

  return <String, String>{
      'id': reg.id!.toString(),
      'company_id': reg.idCompany!.toString(),
      'type': c,
      'description': reg.description!,  
      'acccount_group_id' : reg.idGroup!.toString(),
      'account_group_sequence' : reg.groupSequence!.toString(),    
    };
}

  AccountRegister? _convertRegister(Map<String, dynamic> data){
    try{
      AccountRegister reg = AccountRegister();

      reg.id = int.parse(data['id']);

      if(data['type'] == "C"){
        reg.credit = true;
      }else{
        reg.credit = false;
      }
      reg.description = data['description'] as String;
      
      reg.idGroup = int.parse(data['account_group_id']);
      reg.idCompany = int.parse(data['company_id']);
      reg.groupSequence = int.parse(data['account_group_sequence']);

      return reg;
    }catch(e){
      debugPrint("ACCOUNT ERRO _CONVERTREGISTER $e");
      return null;
    }
}

  Future<void> setData(AccountRegister register) async {
    await ApiRequest.setData(_table,_convertData(register));
  }

  Future<List<AccountRegister>?> getData() async {
    try {
      List<AccountRegister> registers = [];

      var res = await ApiRequest.getAll(_table);
      var data = json.decode(res.body);

      for(var item in data){
        AccountRegister? r = _convertRegister(item);
        registers.add(r!);
      }

      return registers;
    }catch(e){
      debugPrint("ACCOUNT ERRO GETDATA -> $e");
      return null;
    }
  }

  Future<List<AccountRegister>?> getDataByGroup(int idGroup) async {
    try {
      List<AccountRegister> registers = [];

      var res = await ApiRequest.getCustom(
        " SELECT * FROM $_table WHERE account_group_id = '$idGroup' "
      );
      var data = json.decode(res.body);

      for(var item in data){
        AccountRegister? r = _convertRegister(item);
        registers.add(r!);
      }

      return registers;
    }catch(e){
      debugPrint("ERRO GETDATABYGROUP -> $e");
      return null;
    }
  }

  Future<List<AccountRegister>?> getDataType(String type) async {
    try {
      List<AccountRegister> registers = [];

      var res = await ApiRequest.getCustom(
        " SELECT * FROM $_table WHERE type = '$type' "
      );
      var data = json.decode(res.body);

      for(var item in data){
        AccountRegister? r = _convertRegister(item);
        registers.add(r!);
      }

      return registers;
    }catch(e){
      debugPrint("ERRO GETDATATYPE --> $e");
      return null;
    }
  }

  static int getID(List<AccountRegister> list,String descriptionTarget){
    for(int i=0;i<list.length;i++){
      if(list[i].description == descriptionTarget){
        return list[i].id!;          
      }
    }
    return 0;
  } 

  Future<bool> delete(AccountRegister register) async {
    return await ApiRequest.delete(_table,register.id);
  }

  Future<void> update(AccountRegister register) async {
    await ApiRequest.update(_table,_convertData(register), register.id);
  }

}