import 'package:firebase_write/models/account/accountRegister.dart';
import 'package:firebase_write/models/financial_entry/financial_entry_register.dart';
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

  isCredit(){
    return account.credit;
  }

}