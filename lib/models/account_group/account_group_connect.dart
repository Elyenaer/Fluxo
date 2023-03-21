
import 'dart:convert';

import 'package:firebase_write/models/account_group/account_group_register.dart';
import 'package:firebase_write/settings/manager_access/api/api_request.dart';
import 'package:flutter/material.dart';

class AccountGroupConnect {

  final String _table = "account_group";

  Map<String, String> _convertData(AccountGroupRegister reg){
    return <String, String>{
      'company_id' : reg.idCompany!.toString(),
      'description': reg.description!,    
      'sequence': reg.sequence!.toString(),
    };
  }

  AccountGroupRegister? _convertRegister(Map<String, dynamic> data){
    try{
      AccountGroupRegister reg = AccountGroupRegister();

      reg.id = data['account_group_id'];
      reg.idCompany = data['company_id'];
      reg.description = data['description'].toString();
      reg.sequence = data['sequence'];

      return reg;
    }catch(e){
      debugPrint("ACCOUNT GROUP ERRO _CONVERTREGISTER $e");
      return null;
    }
}

  Future<void> setData(AccountGroupRegister register) async {
    await ApiRequest.setData(_table,_convertData(register));
  }

  Future<List<AccountGroupRegister>?> getData() async {
    try {
      List<AccountGroupRegister> registers = [];

      var res = await ApiRequest.getAll(_table);
      var data = json.decode(res.body);

      for(var item in data){
        AccountGroupRegister? r = _convertRegister(item);
        registers.add(r!);
      }

      return registers;
    }catch(e){
      debugPrint("ACCOUNT GROUP ERRO GETDATA -> $e");
      return null;
    }
  }

  Future<void> update(AccountGroupRegister register) async {
    await ApiRequest.update(_table,_convertData(register), register.id);
  }

  Future<bool> delete(AccountGroupRegister register) async {
    return await ApiRequest.delete(_table,register.id);
  }

}