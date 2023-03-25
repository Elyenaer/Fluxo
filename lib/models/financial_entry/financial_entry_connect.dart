
import 'dart:convert';
import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/models/financial_entry/financial_entry_register.dart';
import 'package:firebase_write/settings/manager_access/current_access/current_access.dart';
import 'package:flutter/material.dart';
import '../../settings/manager_access/api/api_request.dart';
import '../../settings/manager_access/api/db_settings_api.dart';

class FinancialEntryConnect {
  
  final String _table = "financial_entry";

  Map<String, String> _convertData(FinancialEntryRegister register){
    return <String, String>{
      'client_id': CurrentAccess.client.id.toString(),
      'description': register.description!,
      'account_id': register.idAccount.toString(),
      'value': register.value.toString(),
      'date': convert.DatetimeToDatabase(register.date!)
    };
  }

  FinancialEntryRegister? _convertRegister(Map<String, dynamic> data){
    try{
      FinancialEntryRegister reg = FinancialEntryRegister();

      reg.id = data['financial_entry_id'];
      reg.idClient = data['client_id'];
      reg.idAccount = data['account_id'];
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

        var res = await ApiRequest.getAllByClient(_table);
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
          " SELECT * FROM ${DBsettingsApi.dbName}$_table WHERE date >= '${convert.DatetimeToDatabase(start)}'" 
          " AND date <= '${convert.DatetimeToDatabase(end)}' AND client_id = '${CurrentAccess.client.id}'"
        );
        var data = json.decode(res.body);

        for(var item in data){
          FinancialEntryRegister? r = _convertRegister(item);
          registers.add(r!);
        }

        return registers;
      }catch(e){
        debugPrint("FINANCIALENTRY REGISTER ERRO GETDATAGAPDATE -> $e");
        return null;
      }
    }

  Future<List<FinancialEntryRegister>?> getDataGapDateIdAccount(int idAccount,DateTime start,DateTime end) async {
    try {
        List<FinancialEntryRegister> registers = [];

        var res = await ApiRequest.getCustom(
          " SELECT * FROM ${DBsettingsApi.dbName}$_table WHERE date >= '${convert.DatetimeToDatabase(start)}'" 
          " AND date <= '${convert.DatetimeToDatabase(end)}' AND account_id = '$idAccount'"
          " AND client_id = '${CurrentAccess.client.id}'"
        );
        var data = json.decode(res.body);

        for(var item in data){
          FinancialEntryRegister? r = _convertRegister(item);
          registers.add(r!);
        }

        return registers;
      }catch(e){
        debugPrint("ERRO GETDATAGAPDATEIDACCOUNT -> $e");
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