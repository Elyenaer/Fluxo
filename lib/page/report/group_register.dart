
import 'package:firebase_write/models/account_group/accountGroupRegister.dart';
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
    _createBalance(rows[0].register.length);
    for(int i=0;i<rows.length;i++){
      for(int j=0;j<balance.length;j++){
        balance[j].add(rows[i].register[j].sum,rows[i].isCredit());
      }
    }    
  }

  _createBalance(int lenght){
    for(int i=0;i<lenght;i++){
      balance.add(GroupCellRegister());
    }
  }


}