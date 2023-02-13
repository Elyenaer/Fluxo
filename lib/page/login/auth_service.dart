
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_write/page/login/login_page.dart';
import 'package:firebase_write/page/report/report_page.dart';
import 'package:flutter/material.dart';

class AuthService {
  //Handle Authentication
  
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const ReportPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }

  //Sign Out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //Sign in
  Future<String> signIn(email, password) async {
    String response = '';
    try{
        await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
          (user) {
          response = 'success';
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