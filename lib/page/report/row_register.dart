
import 'package:firebase_write/database.dart/register/financialEntryRegister.dart';
import 'package:firebase_write/models/account/accountRegister.dart';
import 'package:firebase_write/page/report/cell_register.dart';

class RowRegister{
  late List<CellRegister> register = <CellRegister>[];
  late AccountRegister account;

  RowRegister(this.account,int col){
    for(int i=0;i<col;i++){
      CellRegister c = CellRegister(i);
      register.add(c);
    }
  }

  include(FinancialEntryRegister f,int positionArray){
    register[positionArray].include(f);
  }

}