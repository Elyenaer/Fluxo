
import 'package:firebase_write/custom/widgets/customTextField.dart';
import 'package:flutter/material.dart';

import '../../models/account_group/account_group_connect.dart';
import '../../models/account_group/account_group_register.dart';
import 'package:firebase_write/help/message.dart';

// ignore: non_constant_identifier_names
Future<String> AccountGroupRegisterDialog(BuildContext context,int sequence) async { 

  String result = '';

  AccountGroupConnect connect = AccountGroupConnect();
  AccountGroupRegister register = AccountGroupRegister();

  TextEditingController _tecId = TextEditingController(text: "");
  TextEditingController _tecDescription = TextEditingController(text: '');

  List<Widget> buttons = <Widget>[];
  buttons.add(FloatingActionButton(
    child: const Icon(
      Icons.arrow_back,
    ),
    onPressed: () { 
      Navigator.of(context).pop();
    },
    ),
  );
  buttons.add(FloatingActionButton(
    child: const Icon(
      Icons.add,
    ),
    onPressed: () async { 
      result = 'update';

      register.id = int.parse(_tecId.text);
      register.description = _tecDescription.text;
      register.sequence = sequence;
      await connect.setData(register);
      
      Navigator.of(context).pop('update');
      message.simple(context,"","GRUPO CADASTRADO COM SUCESSO!");
    },
    )
  );
  
  Widget build = Center(
    child: Column(
      children: [
        CustomTextField(
          icon: Icons.article_rounded,
          label: 'ID',
          enabled: false,
          controller: _tecId
        ),
        const SizedBox(height: 20,),
        CustomTextField(
          label: 'Descrição',
          controller: _tecDescription
        )
      ],
    )
  );

  AlertDialog m = AlertDialog(
    title: const Center(
      child: Text('CADASTRO DE GRUPOS'),
    ),
    content: build,
    actionsAlignment: MainAxisAlignment.center,
    actions: buttons,
  );

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return m;
    },
  );

  return result;
}
