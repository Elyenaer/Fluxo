
import 'package:firebase_write/help/message.dart';
import 'package:firebase_write/models/account_group/account_group_connect.dart';
import 'package:firebase_write/models/account_group/account_group_register.dart';
import 'package:flutter/material.dart';

class AccountGroupRegisterController {
  String result = '';

  TextEditingController tecDescription = TextEditingController(text: '');
  int sequence;

  AccountGroupRegisterController(this.sequence);

  save() async{
    try{
      AccountGroupRegister register = AccountGroupRegister();
      
      register.description = tecDescription.text;
      register.sequence = sequence;

      await AccountGroupConnect().setData(register);
      
      return true;
    }catch(e){
      message.error(runtimeType,StackTrace.current,"save", e);
      return false;
    }
  }

}