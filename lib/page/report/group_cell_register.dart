
import 'package:firebase_write/database.dart/register/financialEntryRegister.dart';
import 'package:firebase_write/models/account/accountRegister.dart';

class GroupCellRegister{
  double sum = 0;
  int position;

  GroupCellRegister(this.position);

  include(FinancialEntryRegister register,AccountRegister account){
    if(account.credit!){
      sum += register.value;
    }else{
      sum -= register.value;
    }
  }

}