

// ignore: camel_case_types
import 'package:firebase_write/database.dart/register/financialEntryRegister.dart';

class CellRegister{
  late double sum = 0;
  late int position;
  late List<FinancialEntryRegister> cellRegister = <FinancialEntryRegister>[];

  CellRegister(this.position);

  bool include(FinancialEntryRegister f){
    sum += f.value;
    cellRegister.add(f);
    return true;
  }

}