
import 'package:firebase_write/models/account_group/accountGroupRegister.dart';
import 'package:firebase_write/page/report/group_cell_register.dart';
import 'package:firebase_write/page/report/row_register.dart';

class GroupRegister{
  List<RowRegister> rows = <RowRegister>[];
  List<GroupCellRegister> balance = <GroupCellRegister>[];
  AccountGroupRegister group;
  double sum = 0;

  GroupRegister(this.group);

  add(RowRegister row){
    rows.add(row);
  }

     

}