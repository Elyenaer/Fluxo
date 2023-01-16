
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_write/help/convert.dart';
import 'package:flutter/cupertino.dart';

class FinancialEntryRegister {

final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("financial_entry");

late final int id;
late final int accountId;
late final String description;
late final double value;
late final DateTime date;

Map<String, String> _convertData(){

  //id
  var helpId = '';
  for(var i=0;i<(10-id.toString().length);i++){
    helpId = helpId + '0';
  }
  helpId = helpId + id.toString();

  return <String, String>{
      'id': helpId,
      'description': description,
      'account_id': '$accountId',
      'value': '$value',
      'date': convert.DatetimeToDatabase(date)
    };
}

FinancialEntryRegister? _convertRegister(Map<String, dynamic> data){
  try{
    FinancialEntryRegister reg = FinancialEntryRegister();

    reg.id = int.parse(data['id']);
    reg.accountId = int.parse(data['account_id']);
    reg.description = data['description'] as String;
    reg.date = convert.DatabaseToDatetime(data['date']);
    reg.value = double.parse(data['value']);

    return reg;
  }catch(e){
    print("ERRO _CONVERTREGISTER $e");
    return null;
  }
}

Future<void> setData() async {
  collectionRef.doc('$id').set(_convertData()).catchError((error)
    => debugPrint("Failed to add user: $error"));
}

Future<String> getNextId() async {
  try{
    // ignore: prefer_typing_uninitialized_variables
    var i;
    await collectionRef
    .orderBy("id", descending: true)
    .limit(1)
    .get()
    .then(
      // ignore: avoid_function_literals_in_foreach_calls
      (value) => value.docs.forEach((document) {
        i = document.reference.id.toString();
      }));
    return (int.parse(i)+1).toString();
  }catch(e){
    return '1';
  }
}

Future<List<FinancialEntryRegister>?> getData() async {
    try {
      List<FinancialEntryRegister> registers = [];

      // to get data from all documents sequentially
      await collectionRef.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          registers.add(_convertRegister(result.data() as Map<String,dynamic>) as FinancialEntryRegister);
        }
      });
      return registers;
    }catch(e){
      debugPrint("ERRO GETDATA -> $e");
      return null;
    }
  }

Future<List<FinancialEntryRegister>?> getDataGapDate(DateTime start,DateTime end) async {
    try {
      List<FinancialEntryRegister> registers = [];
      
      // to get data from all documents sequentially      
      await collectionRef
      .where('date', isGreaterThanOrEqualTo: convert.DatetimeToDatabase(start))
      .where('date', isLessThanOrEqualTo: convert.DatetimeToDatabase(end))  
      .orderBy('date', descending: false)    
      .get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          registers.add(_convertRegister(result.data() as Map<String,dynamic>) as FinancialEntryRegister);
        }
      });
      return registers;
    }catch(e){
      debugPrint("ERRO GETDATA -> $e");
      return null;
    }
  }

}