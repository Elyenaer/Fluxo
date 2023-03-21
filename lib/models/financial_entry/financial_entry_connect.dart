
import 'dart:convert';

import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/models/financial_entry/financial_entry_register.dart';
import 'package:flutter/material.dart';

import '../../settings/manager_access/api/api_request.dart';

class FinancialEntryConnect {
  
final String _table = "financial_entry";

Map<String, String> _convertData(FinancialEntryRegister register){
  return <String, String>{
    'id': register.id!.toString(),
    'company_id': register.idCompany!.toString(),
    'description': register.description!,
    'account_id': register.idAccount.toString(),
    'value': register.value.toString(),
    'date': convert.DatetimeToDatabase(register.date!)
  };
}

FinancialEntryRegister? _convertRegister(Map<String, dynamic> data){
  try{
    FinancialEntryRegister reg = FinancialEntryRegister();

    reg.id = int.parse(data['id']);
    reg.idCompany = int.parse(data['company_id']);
    reg.idAccount = int.parse(data['account_id']);
    reg.description = data['description'] as String;
    reg.date = convert.DatabaseToDatetime(data['date']);
    reg.value = double.parse(data['value']);

    return reg;
  }catch(e){
    debugPrint("FINANCIAL ENTRY ERRO _CONVERTREGISTER $e");
    return null;
  }
}

Future<void> setData(FinancialEntryRegister register) async {
  await ApiRequest.setData(_table,_convertData(register));
}

Future<List<FinancialEntryRegister>?> getData() async {
    try {
      List<FinancialEntryRegister> registers = [];

      var res = await ApiRequest.getAll(_table);
      var data = json.decode(res.body);

      for(var item in data){
        FinancialEntryRegister? r = _convertRegister(item);
        registers.add(r!);
      }

      return registers;
    }catch(e){
      debugPrint("FINANCIALENTRYREGISTER ERRO GETDATA -> $e");
      return null;
    }
  }

Future<List<FinancialEntryRegister>?> getDataGapDate(DateTime start,DateTime end) async {
    try {
      List<FinancialEntryRegister> registers = [];

      var res = await ApiRequest.getCustom(
        " SELECT * FROM $_table WHERE date >= '${convert.DatetimeToDatabase(start)}'" 
        " AND date <= '${convert.DatetimeToDatabase(end)}' "
      );
      var data = json.decode(res.body);

      for(var item in data){
        FinancialEntryRegister? r = _convertRegister(item);
        registers.add(r!);
      }

      return registers;
    }catch(e){
      debugPrint("ERRO GETDATAGAPDATE -> $e");
      return null;
    }
  }

Future<List<FinancialEntryRegister>?> getDataGapDateIdAccount(int idAccount,DateTime start,DateTime end) async {
  try {
      List<FinancialEntryRegister> registers = [];

      var res = await ApiRequest.getCustom(
        " SELECT * FROM $_table WHERE date >= '${convert.DatetimeToDatabase(start)}'" 
        " AND date <= '${convert.DatetimeToDatabase(end)}' AND account_id = '$idAccount'"
      );
      var data = json.decode(res.body);

      for(var item in data){
        FinancialEntryRegister? r = _convertRegister(item);
        registers.add(r!);
      }

      return registers;
    }catch(e){
      debugPrint("ERRO GETDATAGAPDATE -> $e");
      return null;
    }
}

Future<void> update(FinancialEntryRegister register) async {
  await ApiRequest.update(_table,_convertData(register), register.id);
}

Future<void> delete(FinancialEntryRegister register) async {
  return await ApiRequest.delete(_table,register.id);
}

}