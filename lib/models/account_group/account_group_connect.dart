
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_write/models/account/accountConnect.dart';
import 'package:firebase_write/models/account_group/account_group_register.dart';
import 'package:firebase_write/help/funcNumber.dart';

class AccountGroupConnect {

  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("account_group");

  Map<String, String> _convertData(AccountGroupRegister reg){
    return <String, String>{
      'id': funcNumber.includeZero(reg.id!,3),
      'description': reg.description!,    
      'sequence': funcNumber.includeZero(reg.sequence!,0),
    };
}

  AccountGroupRegister? _convertRegister(Map<String, dynamic> data){
    try{
      AccountGroupRegister reg = AccountGroupRegister();

      reg.id = int.parse(data['id']);
      reg.description = data['description'].toString();
      reg.sequence = int.parse(data['sequence']);

      return reg;
    }catch(e){
      print("ACCOUNT GROUP ERRO _CONVERTREGISTER $e");
      return null;
    }
}

  Future<void> setData(AccountGroupRegister register) async {
    collectionRef.doc(register.id.toString()).set(_convertData(register)).catchError((error)
      => print("Failed to add user: $error"));
  }

  Future<void> update(AccountGroupRegister register) async {
    collectionRef.doc(register.id.toString()).update(_convertData(register)).catchError((error)
      => print("Failed to add user: $error"));
  }

  Future<bool> delete(AccountGroupRegister register) async {
    try{
      collectionRef.doc(register.id.toString()).delete();
      return true;
    }catch(e){
      print("Failed to add user: $e");
      return false;
    }
  }

  Future<List<AccountGroupRegister>?> getData() async {
    try {
      List<AccountGroupRegister> registers = [];

      // to get data from all documents sequentially
      await collectionRef
        .get().then((querySnapshot) {
          for (var result in querySnapshot.docs) {
            AccountGroupRegister temp = _convertRegister(result.data() as Map<String,dynamic>) as AccountGroupRegister;
            registers.add(temp);
          }
      });
      
      return registers;
    }catch(e){
      print("ACCOUNT GROUP ERRO GETDATA -> $e");
      return null;
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

}