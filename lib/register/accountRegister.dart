
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountRegister {

  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("account");

  late int id;
  late bool credit;
  late String description;

  Map<String, String> _convertData(){

  //id
  var helpId = '';
  for(var i=0;i<(10-id.toString().length);i++){
    helpId = helpId + '0';
  }
  helpId = helpId + id.toString();

  //credit
  var c = 'D';
  if (credit){
    c = 'C';
  }

  return <String, String>{
      'id': helpId,
      'credit': c,
      'description': description
    };
}

  AccountRegister? _convertRegister(Map<String, dynamic> data){
    try{
      AccountRegister reg = AccountRegister();

      reg.id = int.parse(data['id']);
      if(data['credit'] == 'c'){
        reg.credit = true;
      }else{
        reg.credit = false;
      }
      reg.description = data['description'] as String;

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
      await collectionRef.get().then((querySnapshot) {
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
        return list[i].id;          
      }
    }
    return 0;
  }
}