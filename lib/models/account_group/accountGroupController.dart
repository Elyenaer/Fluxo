
import 'package:firebase_write/models/account/accountConnect.dart';
import 'package:firebase_write/models/account_group/accountGroupConnect.dart';
import 'package:firebase_write/models/account_group/accountGroupRegister.dart';

class AccountGroupController {

getGroups() async {
  List<AccountGroupRegister>? group = await AccountGroupConnect().getData();
  return await _getAccounts(group);
}

_getAccounts(List<AccountGroupRegister>? group) async {
  try{
    for(int i=0;i<group!.length;i++){
      group[i].accounts = await AccountConnect().getDataByGroup(group[i].id!);    
    }
    return group;
  }catch(e){
    print("ACCOUNTGROUPCONTROLLER ERRO _GETACCOUNTS $e");
  }  
}

}