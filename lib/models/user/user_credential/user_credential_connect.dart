
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_write/models/user/user_credential/user_credential_register.dart';
import 'package:flutter/material.dart';

class UserCredentialConnect{

   UserCredentialRegister? convertRegister(UserCredential data){
    try{
      UserCredentialRegister reg = UserCredentialRegister();

      reg.email = data.user!.email.toString();

      return reg;
    }catch(e){
      debugPrint("USERCREDENTIALCONNECT ERRO _CONVERTREGISTER $e");
      return null;
    }
}


}