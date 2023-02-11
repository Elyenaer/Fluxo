
import '../../models/account/accountConnect.dart';
import '../../models/account/accountRegister.dart';
import '../../models/account_group/accountGroupRegister.dart';

class AccountManagerGroupRegister {
  AccountGroupRegister group;
  List<AccountRegister> accounts;
  AccountConnect connect = AccountConnect();

  AccountManagerGroupRegister ({
    required this.group,
    required this.accounts,
  });

  replace(int oldIndex,int newindex){    
    accounts[oldIndex].groupSequence = newindex;
    connect.update(accounts[oldIndex]);
    if(oldIndex<newindex){      
      for(int i=newindex;i>oldIndex;i--){
        accounts[i].groupSequence = i-1;
        connect.update(accounts[i]);
      }      
    }else{
      for(int i=newindex;i<oldIndex;i++){
        accounts[i].groupSequence = i+1;
        connect.update(accounts[i]);
      } 
    }        
  }

  remove(int oldIndex){
    accounts.remove(accounts[oldIndex]);
    for(int i = 0;i<accounts.length;i++){
      accounts[i].groupSequence = i;
      connect.update(accounts[i]);
    }
  }

  add(AccountRegister register,int newIndex){

    register.idGroup = group.id;  
    register.groupSequence = newIndex;
    if(newIndex==accounts.length){
      accounts.add(register);
      connect.update(register);
      return;
    }

    List<AccountRegister> list = <AccountRegister>[];  
    for(int i = 0;i<accounts.length;i++){
      if(i<newIndex){
        list.add(accounts[i]);
      }else{
        if(i==newIndex){
          list.add(register);
          connect.update(register);
        }
        accounts[i].groupSequence = i+1;
        list.add(accounts[i]);
        connect.update(accounts[i]);
      }      
    }    
    accounts = list;
  }

  sort(){
    // ignore: prefer_function_declarations_over_variables
    Comparator<AccountRegister> sortById = (a, b) => a.groupSequence!.compareTo(b.groupSequence!);
    accounts.sort(sortById);
  }

}