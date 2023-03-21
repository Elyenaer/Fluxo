
import 'package:firebase_write/models/account_group/account_group_register.dart';
import 'package:firebase_write/help/funcNumber.dart';
import 'package:firebase_write/settings/manager_access/firebase/db_settings.dart';
import 'package:flutter/material.dart';

class AccountGroupConnect {

  final String collection = "account_group";

  Map<String, String> _convertData(AccountGroupRegister reg){
    return <String, String>{
      'id': funcNumber.includeZero(reg.id!,3),
      'description': reg.description!,    
      'sequence': funcNumber.includeZero(reg.sequence!,0),
    };
  }

  AccountGroupRegister? _convertRegister(Map<String, dynamic> data){
    try{
      AccountGroupRegister reg = AccountGroupRegister();

      reg.id = int.parse(data['id']);
      reg.description = data['description'].toString();
      reg.sequence = int.parse(data['sequence']);

      return reg;
    }catch(e){
      debugPrint("ACCOUNT GROUP ERRO _CONVERTREGISTER $e");
      return null;
    }
}

  Future<void> setData(AccountGroupRegister register) async {
    await DBsettings.getDbCollection(collection).doc(register.id.toString()).set(_convertData(register)).catchError((error)
      => debugPrint("Failed to add user: $error"));
  }

  Future<void> update(AccountGroupRegister register) async {
    await DBsettings.getDbCollection(collection).doc(register.id.toString()).update(_convertData(register)).catchError((error)
      => debugPrint("Failed to add user: $error"));
  }

  Future<bool> delete(AccountGroupRegister register) async {
    try{
      await DBsettings.getDbCollection(collection).doc(register.id.toString()).delete();
      return true;
    }catch(e){
      debugPrint("Failed to add user: $e");
      return false;
    }
  }

  Future<List<AccountGroupRegister>?> getData() async {
    try {
      List<AccountGroupRegister> registers = [];

      // to get data from all documents sequentially
      await DBsettings.getDbCollection(collection)
        .get().then((querySnapshot) {
          for (var result in querySnapshot.docs) {
            AccountGroupRegister temp = _convertRegister(result.data() as Map<String,dynamic>) as AccountGroupRegister;
            registers.add(temp);
          }
      });
      
      return registers;
    }catch(e){
      debugPrint("ACCOUNT GROUP ERRO GETDATA -> $e");
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