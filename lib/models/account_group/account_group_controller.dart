
import 'package:firebase_write/models/account/account_connect.dart';
import 'package:firebase_write/models/account_group/account_group_connect.dart';
import 'package:firebase_write/models/account_group/account_group_register.dart';
import 'package:flutter/material.dart';

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
    debugPrint("ACCOUNTGROUPCONTROLLER ERRO _GETACCOUNTS $e");
  }  
}

}