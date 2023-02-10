
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_write/help/funcNumber.dart';

import 'themeRegister.dart';

// ignore: camel_case_types
class ThemeConnect {

  late CollectionReference collectionRef = FirebaseFirestore.instance.collection("theme");

  ThemeRegister? _convertRegister(Map<String, dynamic> data){
    try{
      ThemeRegister register = ThemeRegister();

      register.id = int.parse(data['id']);
      register.name = data['name'];

      register.setBackgrounMain(data['backgroundMain']);
      register.setBackgrounTitle(data['backgroundTitle']);

      register.setForegroundMain(data['foregroundMain']);
      register.setForegroundTitle(data['foregroundTitle']);

      register.setWidgetPrimaryColor(data['widgetPrimaryColor']);
      register.setWidgetSecondaryColor(data['widgetSecondaryColor']);
      register.setWidgetForeground(data['widgetForeground']);
      register.setWidgetTextColor(data['widgetTextColor']);
      register.setWidgetContainer(data['widgetContainer']);

      return register;
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
      .where('id', isEqualTo: funcNumber.includeZero(id,4))    
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





