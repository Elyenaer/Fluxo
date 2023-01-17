
import 'package:flutter/material.dart';

// ignore: camel_case_types
class message{
  
static void simple(BuildContext context,String title,String text) { 

  Widget okButton = FloatingActionButton(
    child: const Text("OK"),
    onPressed: () { 
       Navigator.of(context).pop();
    },
  );

  AlertDialog m = AlertDialog(
    title: Text(title),
    content: Text(text),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return m;
    },
  );
}

static Future<bool> confirm(BuildContext context,String title,String text) async { 
  bool confirm = false;

  Widget okButton = TextButton(
    child: const Text("CONFIRMAR"),
    onPressed: () { 
       Navigator.of(context).pop();
       confirm = true;
    },
  );

  Widget cancelButton = TextButton(
    child: const Text("CANCELAR"),
    onPressed: () { 
       Navigator.of(context).pop();
       confirm = false;
    },
  );

  AlertDialog m = AlertDialog(
    title: Text(title),
    content: Text(text),
    actions: [
      cancelButton,
      okButton,
    ],
  );

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return m;
    },
  );

  return confirm;
}

}