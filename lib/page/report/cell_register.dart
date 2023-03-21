

// ignore: camel_case_types

import 'package:firebase_write/models/financial_entry/financial_entry_register.dart';

class CellRegister{
  double sum = 0;
  late int position;
  late List<FinancialEntryRegister> cellRegister = <FinancialEntryRegister>[];

  CellRegister(this.position);

  bool include(FinancialEntryRegister f){
    sum += f.value!;
    cellRegister.add(f);
    return true;
  }

}