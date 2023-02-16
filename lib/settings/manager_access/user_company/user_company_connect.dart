
import 'package:firebase_write/help/funcNumber.dart';
import 'package:firebase_write/settings/manager_access/firebase/db_settings.dart';
import 'package:firebase_write/settings/manager_access/user_company/user_company_register.dart';
import 'package:flutter/material.dart';

class UserCompanyConnect {
  String collection = "connect_user_company";

  UserCompanyRegister? _convertRegister(Map<String, dynamic> data){
    try{
      UserCompanyRegister reg = UserCompanyRegister();

      reg.id = int.parse(data['id']);
      reg.idUser = int.parse(data['id_user']);
      reg.idCompany = int.parse(data['id_company']);
      reg.companyName = data['company_name'];

      return reg;
    }catch(e){
      debugPrint("USERCOMPANYCONNECT ERRO _CONVERTREGISTER $e");
      return null;
    }
  }

  Future<List<UserCompanyRegister?>?> getByIdUser(int idUser) async {
    try{
      List<UserCompanyRegister?> register = [];

      await DBsettings.getManagerCollection(collection).
      where("id_user", isEqualTo:funcNumber.includeZero(idUser,5)).get().then((querySnapshot) async {
        for (var result in querySnapshot.docs) {
          register.add(_convertRegister(result.data() as Map<String,dynamic>));          
        }
      });

      return register;      
    }catch(e){
      debugPrint("USERCOMPNAYCONNECT GETBYID $e");
      return null;
    }
  } 

}