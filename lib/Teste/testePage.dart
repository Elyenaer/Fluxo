// ignore_for_file: file_names
import 'package:firebase_write/models/account_group/account_group_connect.dart';
import 'package:flutter/material.dart';

class Teste extends StatelessWidget {
  const Teste({Key? key}) : super(key: key);

  f(){
    try{
      /*AccountGroupRegister r = AccountGroupRegister();

      r.description = "teste";
      r.sequence = 0;

      AccountGroupConnect().setData(r);*/

      AccountGroupConnect().getData();
    }catch(e){
      print("Erro -> $e");
    }
  }

  @override
  Widget build(BuildContext context) { 
    //f();
    return const Scaffold();    
  }

}
