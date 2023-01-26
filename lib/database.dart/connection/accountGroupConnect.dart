
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_write/database.dart/register/accountGroupRegister.dart';
import 'package:firebase_write/help/funcNumber.dart';

class AccountGroupConnect {

  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("account_group");

  Map<String, String> _convertData(AccountGroupRegister reg){
    return <String, String>{
      'id': funcNumber.includeZero(reg.id!,3),
      'description': reg.description!,    
    };
}

  AccountGroupRegister? _convertRegister(Map<String, dynamic> data){
    try{
      AccountGroupRegister reg = AccountGroupRegister();

      reg.id = int.parse(data['id']);
      reg.description = data['description'].toString();

      return reg;
    }catch(e){
      print("ERRO _CONVERTREGISTER $e");
      return null;
    }
}

  Future<List<AccountGroupRegister>?> getData() async {
    try {
      List<AccountGroupRegister> registers = [];

      // to get data from all documents sequentially
      await collectionRef
        .get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          registers.add(_convertRegister(result.data() as Map<String,dynamic>) as AccountGroupRegister);
        }
      });
      
      return registers;
    }catch(e){
      print("ERRO GETDATA -> $e");
      return null;
    }
  }

}