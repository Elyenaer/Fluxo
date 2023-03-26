
import 'package:firebase_write/help/message.dart';
import 'package:firebase_write/models/account_group/account_group_register.dart';
import 'package:firebase_write/page/report/group_cell_register.dart';
import 'package:firebase_write/page/report/row_register.dart';

class GroupRegister{
  List<RowRegister> rows = <RowRegister>[];
  List<GroupCellRegister> balance = <GroupCellRegister>[];
  AccountGroupRegister group;
  bool rowIsShowing = true;

  GroupRegister(this.group);

  add(RowRegister row){
    rows.add(row);
  }

  updateBalance(){
    try{
      _createBalance(rows[0].register.length);
      for(int i=0;i<rows.length;i++){
        for(int j=0;j<balance.length;j++){      
          balance[j].add(rows[i].register[j].sum,rows[i].isCredit());
        }
      } 
    }catch(e){
      message.error(runtimeType,StackTrace.current,"updateBalance", e);
    }       
  }

  _createBalance(int lenght){
    try{
      for(int i=0;i<lenght;i++){
        balance.add(GroupCellRegister());
      }
    }catch(e){
      message.error(runtimeType,StackTrace,"_getBalances",e);
    }    
  }

  sort(){
    // ignore: prefer_function_declarations_over_variables
    Comparator<RowRegister> sortBySequence = (a, b) => a.account.groupSequence!.compareTo(b.account.groupSequence!);
    rows.sort(sortBySequence);
  }


}