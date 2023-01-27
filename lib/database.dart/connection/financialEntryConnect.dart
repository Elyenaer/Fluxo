
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_write/database.dart/register/accountRegister.dart';
import 'package:firebase_write/database.dart/register/financialEntryRegister.dart';
import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/help/funcNumber.dart';

class FinancialEntryConnect {
  
final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("financial_entry");

Map<String, String> _convertData(FinancialEntryRegister register){
  return <String, String>{
    'id': funcNumber.includeZero(register.id,10),
    'description': register.description,
    'account_id': register.accountId.toString(),
    'value': register.value.toString(),
    'date': convert.DatetimeToDatabase(register.date)
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

Future<void> setData(FinancialEntryRegister register) async {
  collectionRef.doc(register.id.toString()).set(_convertData(register)).catchError((error)
    => print("Failed to add user: $error"));
}

Future<void> update(FinancialEntryRegister register) async {
  collectionRef.doc(register.id.toString()).update(_convertData(register)).catchError((error)
    => print("Failed to add user: $error"));
}

Future<void> delete(FinancialEntryRegister register) async {
  try{
    collectionRef.doc(register.id.toString()).delete();
  }catch(e){
     print("Failed to add user: $e");
  }
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
      print("ERRO GETDATA -> $e");
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
      print("ERRO GETDATAGAPDATE -> $e");
      return null;
    }
  }

Future<List<FinancialEntryRegister>?> getDataGapDateIdAccount(int idAccount,DateTime start,DateTime end) async {
  try {
    List<FinancialEntryRegister> registers = [];
    
    // to get data from all documents sequentially      
    await collectionRef
    .where('date', isGreaterThanOrEqualTo: convert.DatetimeToDatabase(start))
    .where('date', isLessThanOrEqualTo: convert.DatetimeToDatabase(end))  
    .where('account_id', isEqualTo: idAccount.toString()) 
    .orderBy('date', descending: false)    
    .get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        registers.add(_convertRegister(result.data() as Map<String,dynamic>) as FinancialEntryRegister);
      }
    });
    return registers;
  }catch(e){
    print("ERRO GETDATAGAPDATEIDACCOUNT -> $e");
    return null;
  }
}

//check if there are financial registers in determined account,
// its done before account is deleted
Future<bool> checkAccount(int idAccount) async {
  try {         
    await collectionRef
    .where('account_id', isEqualTo: idAccount.toString())   
    .get().then((querySnapshot) {
        if(querySnapshot.docs.isEmpty){
          return false;
        }else{
          return true;
        }
      }
    );
    return false;
  }catch(e){
    print("ERRO CHECKACCOUNT -> $e");
    return false;
  }
}



}