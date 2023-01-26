
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_write/database.dart/register/accountRegister.dart';
import 'package:firebase_write/help/funcNumber.dart';

class AccountConnect {

  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("account");

  Map<String, String> _convertData(AccountRegister reg){
    
  //credit
    var c = 'D';
    if (reg.credit!){
      c = 'C';
    }

  return <String, String>{
      'id': funcNumber.includeZero(reg.id!,10),
      'credit': c,
      'description': reg.description!,  
      'id_group' : reg.idGroup.toString(),
      'sequence' : reg.groupSequence.toString(),    
    };
}

  AccountRegister? _convertRegister(Map<String, dynamic> data){
    try{
      AccountRegister reg = AccountRegister();

      reg.id = int.parse(data['id']);

      if(data['type'] == "C"){
        reg.credit = true;
      }else{
        reg.credit = false;
      }
      reg.description = data['description'] as String;
      
      reg.idGroup = int.parse(data['id_group']);
      reg.groupSequence = int.parse(data['group_sequence']);

      return reg;
    }catch(e){
      print("ERRO _CONVERTREGISTER $e");
      return null;
    }
}

  Future<List<AccountRegister>?> getData() async {
    try {
      List<AccountRegister> registers = [];

      // to get data from all documents sequentially
      await collectionRef
        .get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          registers.add(_convertRegister(result.data() as Map<String,dynamic>) as AccountRegister);
        }
      });
      
      return registers;
    }catch(e){
      print("ERRO GETDATA -> $e");
      return null;
    }
  }

  Future<List<AccountRegister>?> getDataType(String type) async {
    try {
      List<AccountRegister> registers = [];

      // to get data from all documents sequentially
      await collectionRef
      .where('type', isEqualTo: type)
      .get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          registers.add(_convertRegister(result.data() as Map<String,dynamic>) as AccountRegister);
        }
      });

      return registers;
    }catch(e){
      print("ERRO GETDATA --> $e");
      return null;
    }
  }

  static int getID(List<AccountRegister> list,String descriptionTarget){
    for(int i=0;i<list.length;i++){
      if(list[i].description == descriptionTarget){
        return list[i].id!;          
      }
    }
    return 0;
  }   

}