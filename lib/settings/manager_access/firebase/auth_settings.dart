
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_write/models/user/user_credential/user_credential_connect.dart';
import 'package:firebase_write/settings/manager_access/current_access/current_access.dart';
import 'package:flutter/material.dart';

class AuthSettings {
  static late FirebaseAuth auth;

  //Handle Authentication
  /*
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instanceFor(app: DBsettings.managerAccess).authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const ReportPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }*/

  static start() async {
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
      auth = FirebaseAuth.instanceFor(app: appManagerUser);
    }catch(e){
      debugPrint('ERRO STARTMANAGERUSER -> $e');
      return null;
    }
  }  

  //Sign Out
  signOut() {
    auth.signOut();
  }

  //Sign in
  Future<String> signIn(email, password) async {
    String response = '';
    try{
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password
      ).then((userCredential) async {
          await CurrentAccess().userStart(
            UserCredentialConnect().convertRegister(userCredential)!
          );
        }
      ).catchError(
        (e) {
          response = e;
        }
      );
      return response;
    }catch(e){
      response = e.toString();
      return response;
    }
  }

}