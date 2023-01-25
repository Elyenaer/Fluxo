
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';

import '../register/themeRegister.dart';

// ignore: camel_case_types
class ThemeConnect {

  late CollectionReference collectionRef = FirebaseFirestore.instance.collection("theme");

  String _helpId(int id){
    var helpId = '';
    for(var i=0;i<(4-id.toString().length);i++){
      helpId = helpId + '0';
    }
    helpId = helpId + id.toString();
    return helpId;
  }

  ThemeRegister? _convertRegister(Map<String, dynamic> data){
    try{
      ThemeRegister reg = ThemeRegister();

      reg.id = int.parse(data['id']);
      reg.name = data['name'];

      reg.setBackgrounMain(data['backgroundMain']);
      reg.setBackgrounTitle(data['backgroundTitle']);

      reg.setForegroundMain(data['foregroundMain']);
      reg.setForegroundTitle(data['foregroundTitle']);

      reg.setWidgetPrimaryColor(data['widgetPrimaryColor']);
      reg.setWidgetSecondaryColor(data['widgetSecondaryColor']);
      reg.setWidgetForeground(data['widgetForeground']);
      reg.setWidgetTextColor(data['widgetTextColor']);

      return reg;
    }catch(e){
      print("ERRO _CONVERTREGISTER $e");
      return null;
    }
}

  Future<ThemeRegister?> getId(int id) async {
    try {
      ThemeRegister? register;

      // to get data from all documents sequentially      
      await collectionRef
      .where('id', isEqualTo: _helpId(id))    
      .get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          register = _convertRegister(result.data() as Map<String,dynamic>) as ThemeRegister;
        }
      });

      return register;
    }catch(e){
      print("ERRO GETID -> $e");
      return null;
    }
  }

  Future<Map<String, String>?> get(int id) async {
    try {

      // to get data from all documents sequentially      
      await collectionRef
      .where('id', isGreaterThanOrEqualTo: id)    
      .get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          return result.data();
        }
      });

      return null;
    }catch(e){
      print("ERRO GETDATA -> $e");
      return null;
    }
  }

}




