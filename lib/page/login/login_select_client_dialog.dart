
import 'package:firebase_write/models/client/client_register.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Future<int?> LoginSelectClientDialog(BuildContext context,List<ClientRegister?> clients) async { 

  int? result = 0;

  List<Widget> buttonsClients = <Widget>[];

  for(var c in clients){
    buttonsClients.add(
      TextButton(
        onPressed: () { 
          result = c!.id!;
          Navigator.of(context).pop(c.id);
        },
        child: Text(c!.name!)
      )
    );
  }

  AlertDialog m = AlertDialog(
    title: const Center(
      child: Text('SELECIONE O ACESSO'),
    ),
    actionsAlignment: MainAxisAlignment.center,
    actions: buttonsClients,
  );

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return m;
    },
  );

  return result;
}