import 'package:firebase_write/settings/manager_access/company/company_register.dart';
import 'package:firebase_write/settings/manager_access/firebase/db_settings.dart';
import 'package:flutter/material.dart';

class CompanyConnect {
  String collection = 'company';
  
  CompanyRegister? _convertRegister(Map<String, dynamic> data){
    try{
      CompanyRegister reg = CompanyRegister();

      reg.id = int.parse(data['id']);
      reg.name = data['name'] as String;
      reg.apikey = data['apikey'] as String;
      reg.appID = data['appId'] as String;
      reg.authDomain = data['authDomain'] as String;
      reg.measurementId = data['measurementId'] as String;
      reg.messagingSenderId = data['messagingSenderId'] as String;
      reg.projectId = data['projectId'] as String;
      reg.storageBucket = data['storageBucket'] as String;

      return reg;
    }catch(e){
      debugPrint("COMPANYRREGISTER ERRO _CONVERTREGISTER $e");
      return null;
    }
  }

  Future<CompanyRegister?> getById(int id) async {
    try {
      CompanyRegister registers = CompanyRegister();
      
      // to get data from all documents sequentially      
      await DBsettings.getManagerCollection(collection).where('id', isEqualTo: id.toString())  
      .get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          registers = _convertRegister(result.data())!;
        }
      });

      return registers;
    }catch(e){
      debugPrint("COMPANYREGISTER ERRO GETBYID -> $e");
      return null;
    }
  }

  Future<String> getNextId() async {
    try{
      // ignore: prefer_typing_uninitialized_variables
      var i;
      await DBsettings.getManagerCollection(collection)
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
      print(e);
      return '1';
    }
  }

}