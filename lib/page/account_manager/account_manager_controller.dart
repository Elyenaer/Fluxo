
import 'package:firebase_write/page/account_manager/account_manager_group_register.dart';
import 'package:firebase_write/page/report/group_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_write/help/message.dart';
import '../../models/account/accountConnect.dart';
import '../../models/account/accountRegister.dart';
import '../../models/account_group/account_group_connect.dart';
import '../../models/account_group/account_group_register.dart';

enum AccountManagerState {loading,loaded}

class AccountManagerController with ChangeNotifier{ 
  final List<AccountManagerGroupRegister> allLists = [];
  var state = AccountManagerState.loading;

  AccountManagerController(){
    update();
  }

  _setState(AccountManagerState s){
    state = s;
    notifyListeners();
  }

  update() async{
    _setState(AccountManagerState.loading);
    await _getAccount();
    _setState(AccountManagerState.loaded);
  }

  updateGroup(AccountGroupRegister group){
    _setState(AccountManagerState.loading);
     AccountGroupConnect().update(group);
    _setState(AccountManagerState.loaded);
  }
  
  _getAccount() async {    
    List<AccountGroupRegister>? group = await AccountGroupConnect().getData();
    List<AccountRegister>? account = await AccountConnect().getData();

    allLists.clear();
    for(int i=0;i<group!.length;i++){
      List<AccountRegister> _items = <AccountRegister> [];
      for(int j=0;j<account!.length;j++){
        if(group[i].id==account[j].idGroup){
          _items.add(account[j]);
        }
      }
      allLists.add(AccountManagerGroupRegister(
        group: group[i], 
        accounts: _items,
      ));
    }    
    _updateList();    
  } 

  _updateList(){    
    // ignore: prefer_function_declarations_over_variables
    Comparator<AccountManagerGroupRegister> sortbyId = (a, b) => a.group.sequence!.compareTo(b.group.sequence!);   
    allLists.sort(sortbyId);
  }

  deleteGroup(BuildContext context, AccountManagerGroupRegister group) async {
    if(await message.confirm(context,"CONFIRMA A EXCLUSÃO?","VOCÊ TEM CERTEZA QUE DESEJA EXCLUIR O GRUPO?")==false){
      return;
    }
    await AccountGroupConnect().delete(group.group);
    message.simple(context,'',"GRUPO EXCLUÍDO COM SUCESSO!");
    allLists.remove(group);
    _getAccount();
  }

}