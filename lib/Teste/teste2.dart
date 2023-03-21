import 'package:firebase_write/models/account_group/account_group_register.dart';
import 'package:flutter/material.dart';

import '../models/account_group/account_group_connect.dart';

class Teste2 extends StatelessWidget {
  const Teste2({Key? key}) : super(key: key);

  f() async {
    try{
      AccountGroupRegister r = AccountGroupRegister();

      r.id = 1;
      r.description = "teste update";
      r.sequence = 0;

      await AccountGroupConnect().update(r);
    }catch(e){
      print("Erro -> $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    f();
    return const Scaffold();
  }

}