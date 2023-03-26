
import 'package:firebase_write/help/message.dart';
import 'package:firebase_write/models/account/account_connect.dart';
import 'package:firebase_write/models/account/account_register.dart';
import 'package:flutter/material.dart';

class AccountRegisterController {
  TextEditingController tecDescription = TextEditingController(text: "");
  bool isCredit = true;

  String result = '';
  late AccountRegister register;

  int? idGroup;
  int? sequence;

  AccountRegisterController(AccountRegister? account,this.idGroup,this.sequence){
    // ignore: unnecessary_null_comparison
    if(account!=null){
      register = account;
      tecDescription.text = account.description.toString(); 
      isCredit = account.credit!;   
    }else{
      register = AccountRegister();
    }  
  }

  update() async {
    try{
      result = 'update';

      register.description = tecDescription.text;
      register.credit = isCredit;
      await AccountConnect().update(register);

      return true;
    }catch(e){
      message.error(runtimeType,StackTrace.current,"update", e);
      return false;
    }  
  }

  save() async {
    try{
      register.description = tecDescription.text;
      register.idGroup = idGroup;
      register.credit = isCredit;
      register.groupSequence = sequence;
      await AccountConnect().setData(register);

      return true;
    }catch(e){
      message.error(runtimeType,StackTrace.current,"save", e);
      return false;
    }
  }

  delete() async {
    try{
      await AccountConnect().delete(register);
      return true;
    }catch(e){
      message.error(runtimeType,StackTrace.current,"delete", e);
      return false;
    }    
  }  

}