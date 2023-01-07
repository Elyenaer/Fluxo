
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

}