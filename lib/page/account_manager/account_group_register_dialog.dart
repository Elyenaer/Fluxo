
import 'package:firebase_write/custom/widgets/customTextField.dart';
import 'package:firebase_write/page/account_manager/account_group_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_write/help/message.dart';

// ignore: non_constant_identifier_names
Future<String> AccountGroupRegisterDialog(BuildContext context,int sequence) async {   

  AccountGroupRegisterController _controller = AccountGroupRegisterController(sequence);

  List<Widget> buttons = <Widget>[];
  buttons.add(
    FloatingActionButton(    
      child: const Icon(
        Icons.arrow_back,
      ),
      onPressed: () { 
        Navigator.of(context).pop();
      },
    ),
  );
  buttons.add(
    FloatingActionButton(
      child: const Icon(
        Icons.add,
      ),
      onPressed: () async { 
        if(await _controller.save()){
          Navigator.of(context).pop('update');
          message.simple(context,"","GRUPO CADASTRADO COM SUCESSO!");
        }else{
          message.simple(context,"ERRO","ALGO DEU ERRADO");
        }
      },
    )
  );
  
  Widget build = Center(
    child: Column(
      children: [
        const SizedBox(height: 20,),
        CustomTextField(
          label: 'Descrição',
          controller: _controller.tecDescription
        )
      ],
    )
  );

  AlertDialog m = AlertDialog(
    title: const Center(
      child: Text('CADASTRO DE GRUPOS'),
    ),
    content: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 100.0,
          minWidth: 100.0, 
        ),
        child: build,
      ),
    ),
    actionsAlignment: MainAxisAlignment.center,
    actions: buttons,
  );

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return m;
    },
  );

  return _controller.result;
}
