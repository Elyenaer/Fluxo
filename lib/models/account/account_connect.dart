
import 'package:firebase_write/models/financial_entry/financial_entry_connect.dart';
import 'package:firebase_write/help/funcNumber.dart';
import 'package:firebase_write/models/account/account_register.dart';
import 'package:firebase_write/settings/manager_access/firebase/db_settings.dart';
import 'package:flutter/material.dart';

class AccountConnect {

  final String collection = "account";

  Map<String, String> _convertData(AccountRegister reg){
    
  //credit
    var c = 'D';
    if (reg.credit!){
      c = 'C';
    }

  return <String, String>{
      'id': funcNumber.includeZero(reg.id!,4),
      'type': c,
      'description': reg.description!,  
      'id_group' : funcNumber.includeZero(reg.idGroup!,3),
      'group_sequence' : funcNumber.includeZero(reg.groupSequence!,3),    
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
      
      reg.idGroup = int.parse(data['id_group']);
      reg.groupSequence = int.parse(data['group_sequence']);

      return reg;
    }catch(e){
      debugPrint("ACCOUNT ERRO _CONVERTREGISTER $e");
      return null;
    }
}

  Future<void> setData(AccountRegister register) async {
    await DBsettings.getDbCollection(collection).doc(register.id.toString()).set(_convertData(register)).catchError((error)
      => debugPrint("Failed to add user: $error"));
}

  Future<List<AccountRegister>?> getData() async {
    try {
      List<AccountRegister> registers = [];

      // to get data from all documents sequentially
      await DBsettings.getDbCollection(collection).get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          registers.add(_convertRegister(result.data() as Map<String,dynamic>) as AccountRegister);
        }
      });
      
      return registers;
    }catch(e){
      debugPrint("ERRO GETDATA -> $e");
      return null;
    }
  }

  Future<List<AccountRegister>?> getDataByGroup(int idGroup) async {
    try {
      List<AccountRegister> registers = [];

      // to get data from all documents sequentially
      await await DBsettings.getDbCollection(collection)
        .where('id_group', isEqualTo: idGroup)
        .get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          registers.add(_convertRegister(result.data() as Map<String,dynamic>) as AccountRegister);
        }
      });
      
      return registers;
    }catch(e){
      debugPrint("ERRO GETDATA -> $e");
      return null;
    }
  }

  Future<bool> delete(AccountRegister register) async {
    try{
      //check if there are registers in account
      if(await FinancialEntryConnect().checkAccount(register.id!)){
        return false;
      }
      await DBsettings.getDbCollection(collection).doc(register.id.toString()).delete();
      return true;
    }catch(e){
      debugPrint("Failed to add user: $e");
      return false;
    }
  }

  Future<void> update(AccountRegister register) async {
    await DBsettings.getDbCollection(collection).doc(register.id.toString()).update(_convertData(register)).catchError((error)
      => debugPrint("Failed to add user: $error"));
  }

  Future<List<AccountRegister>?> getDataType(String type) async {
    try {
      List<AccountRegister> registers = [];

      // to get data from all documents sequentially
      await DBsettings.getDbCollection(collection)
      .where('type', isEqualTo: type)
      .get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          registers.add(_convertRegister(result.data() as Map<String,dynamic>) as AccountRegister);
        }
      });

      return registers;
    }catch(e){
      debugPrint("ERRO GETDATA --> $e");
      return null;
    }
  }

  Future<String> getNextId() async {
  try{
    // ignore: prefer_typing_uninitialized_variables
    var i;
    await DBsettings.getDbCollection(collection)
    .orderBy("id", descending: true)
    .limit(1)
    .get()
    .then(
      // ignore: avoid_function_literals_in_foreach_calls
      (value) => value.docs.forEach((document) {
        i = document.reference.id.toString();
      }));
    return (int.parse(i)+1).toString();
  }catch(e){
    return '1';
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