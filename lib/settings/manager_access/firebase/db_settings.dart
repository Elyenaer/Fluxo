
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_write/settings/manager_access/company/company_register.dart';
import 'package:flutter/material.dart';

class DBsettings{

  static late FirebaseFirestore databaseCompany;
  static late FirebaseFirestore managerAccess;

  static startManagerUser() async {
    try{
      FirebaseOptions options =  const FirebaseOptions(
          apiKey: "AIzaSyAimy9hMv3ft2EbiRRGPRsznklHeJ1Ug2A",
          authDomain: "elyfluxo.firebaseapp.com",
          projectId: "elyfluxo",
          storageBucket: "elyfluxo.appspot.com",
          messagingSenderId: "481729723898",
          appId: "1:481729723898:web:7bcb151941755ecbcbf843"
        );
      FirebaseApp appManagerUser = await Firebase.initializeApp(options: options);  
      managerAccess = FirebaseFirestore.instanceFor(app: appManagerUser);
    }catch(e){
      debugPrint('ERRO STARTMANAGERUSER -> $e');
    }
  }
  

  static startCompanyDatabase(CompanyRegister register) async {
    try{
      FirebaseOptions options = FirebaseOptions(
        apiKey: register.apikey!,
        authDomain: register.authDomain!,
        projectId: register.projectId!,
        storageBucket: register.storageBucket,
        messagingSenderId: register.messagingSenderId!,
        appId: register.appID!,
        measurementId: register.measurementId
      );
      FirebaseApp appCompanyDatabase = await Firebase.initializeApp(options: options,name: 'companyDatabase');  
      databaseCompany =  FirebaseFirestore.instanceFor(app: appCompanyDatabase);
    }catch(e){
      debugPrint("ERRO STARTCOMPANYDATABASE -> $e");

    }
  }

  static getDbCollection(String collection){
    return databaseCompany.collection(collection);
  }

  static getManagerCollection(String collection){
    return managerAccess.collection(collection);
  }


}