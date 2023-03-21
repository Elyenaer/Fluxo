/*
import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/help/funcNumber.dart';
import 'package:firebase_write/models/user_preferences/user_preferences_register.dart';
import 'package:firebase_write/settings/manager_access/firebase/db_settings.dart';
import 'package:flutter/material.dart';

class UserPreferencesConnect {

  final collection = "user_preferences";

  UserPreferencesRegister? _convertRegister(Map<String, dynamic> data){
    try{
      UserPreferencesRegister register = UserPreferencesRegister();

      register.id_user = int.parse(data['id_user']);
      register.id_theme = int.parse(data['id_theme']);

      register.scale = double.parse(data['scale']);
      
      register.period_report = data['period_report'];
      register.start_date_report = convert.DatabaseToDatetime(data['start_date_report']);
      register.end_date_report = convert.DatabaseToDatetime(data['end_date_report']);

      return register;
    }catch(e){
      debugPrint("ERRO USERPREFERENCESCONNECT _CONVERTREGISTER $e");
      return null;
    }
}

  Map<String, String> _convertData(UserPreferencesRegister register){
    return <String, String>{
      'id_user': funcNumber.includeZero(register.id_user!,5),
      'start_date_report': convert.DatetimeToDatabase(register.start_date_report!),
      'end_date_report': convert.DatetimeToDatabase(register.end_date_report!),
      'scale': register.scale.toString(),
      'id_theme': register.id_theme.toString(),
      'period_report': register.period_report!
    };
  }

  Future<UserPreferencesRegister?> getById(int idUser) async {
    try {
      UserPreferencesRegister? register;

      // to get data from all documents sequentially      
      await collectionRef
      .where('id_user', isEqualTo: funcNumber.includeZero(idUser,5))    
      .get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          register = _convertRegister(result.data() as Map<String,dynamic>);
        }
      });

      return register;
    }catch(e){
      debugPrint("ERRO GETID -> $e");
      return null;
    }
  }

  Future<void> update(UserPreferencesRegister register) async {
    await DBsettings.getDbCollection(collection).doc(register.id_user.toString()).update(_convertData(register)).catchError((error)
      => debugPrint("Failed to add user: $error"));
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
*/




