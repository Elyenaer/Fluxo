import 'package:firebase_write/models/financial_entry/financial_entry_register.dart';
import 'package:firebase_write/models/financial_entry/financial_entry_connect.dart';
import 'package:flutter/material.dart';
import 'package:firebase_write/help/message.dart';
import 'package:firebase_write/help/convert.dart';

enum ListFinancialRegisterState {loading,loaded}

class ListFinancialRegisterController with ChangeNotifier{
  List<FinancialEntryRegister>? registers;
  var state = ListFinancialRegisterState.loaded;
  int? accountId;
  DateTime? start,end;

  setData(int accountId,DateTime start,DateTime end){
    this.accountId = accountId;
    this.start = start;
    this.end = end;
  }

  update(){
    _setState(ListFinancialRegisterState.loading); 
    _getRegisters();
    _setState(ListFinancialRegisterState.loaded);  
  }

  // ignore: unused_element
  void _setState(ListFinancialRegisterState s){
    state = s;
    notifyListeners();   
  }

  _getRegisters() async { 
    registers = await FinancialEntryConnect().getDataGapDateIdAccount(accountId!,start!,end!);
  }

  void deleteFinancialRegister(BuildContext context,FinancialEntryRegister r) async {  
    bool confirm = await message.confirm(context,"CONFIRMA EXCLUSÃO?",
      "ID: " + r.id.toString() 
      + "\nDATA: " + convert.DatetimeToDateBr(r.date!) + "\n" 
      + r.description!.toUpperCase()
      + "\nVALOR: "
      + convert.doubleToCurrencyBR(r.value!)
    ); 

    if(confirm){      
      _setState(ListFinancialRegisterState.loading);   
      await FinancialEntryConnect().delete(r);  
      registers?.remove(r);  
      _setState(ListFinancialRegisterState.loaded); 
    }    
  }
  
}