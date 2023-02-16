
import 'package:firebase_write/settings/manager_access/firebase/db_settings.dart';
import 'package:firebase_write/settings/manager_access/user/user_register.dart';
import 'package:flutter/material.dart';

class UserConnect {
  String collection = "user";

  UserRegister? _convertRegister(Map<String, dynamic> data)  {
    try{
      UserRegister reg = UserRegister();

      reg.id = int.parse(data['id']);
      reg.name = data['name'] as String;
      reg.uid = data['uid'] as String;
      reg.email = data['email'] as String;

      return reg;
    }catch(e){
      debugPrint("USER ERRO _CONVERTREGISTER $e");
      return null;
    }
  }

  Future<UserRegister?> getByUid(String uid) async {
    try{
      UserRegister? register;
      await DBsettings.getManagerCollection(collection).where('uid', isEqualTo: uid).get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          register =  _convertRegister(result.data() as Map<String,dynamic>) as UserRegister;
        }
      });   
      return register; 
    }catch(e){
      debugPrint("USER GETBYUID $e");
      return null;
    }
  }

}