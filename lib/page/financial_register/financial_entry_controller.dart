
import 'package:firebase_write/models/account/account_connect.dart';
import 'package:firebase_write/models/account/account_register.dart';
import 'package:firebase_write/models/financial_entry/financial_entry_register.dart';
import 'package:firebase_write/models/financial_entry/financial_entry_connect.dart';
import 'package:flutter/material.dart';
import 'package:firebase_write/help/message.dart';
import 'package:firebase_write/help/convert.dart';


enum FinancialEntryState {loading,loaded}

class FinancialEntryController with ChangeNotifier{
  var state = FinancialEntryState.loading;

  late FinancialEntryRegister register;
  bool isLoading = true;

  // ignore: non_constant_identifier_names
  late List<AccountRegister>? _account_credit;
  // ignore: non_constant_identifier_names
  late List<AccountRegister>? _account_debit;

  late List<String> typeList = <String>[' '];
  late String typeValue = typeList.first;

  String? errorValue;
  String? errorDate;

  bool isCredit = true;

  final TextEditingController tdcId = TextEditingController(text: '');
  final TextEditingController tdcDescription = TextEditingController(text: '');
  final TextEditingController tdcDate = TextEditingController(text: '');
  final TextEditingController tdcValue = TextEditingController(text: '');

  bool btInclude = false,
      btDelete = false,
      btUpdate = false,
      btClear = false;

  void _setState(FinancialEntryState s) {
    state = s;
    notifyListeners();
  }

  // ignore: annotate_overrides
  dispose(){   
    tdcId.dispose();
    tdcDescription.dispose();
    tdcDate.dispose();
    tdcValue.dispose();
    super.dispose();
  }

  setData(FinancialEntryRegister? r) async {

    if (r != null) {
      register = r;
      await _startScreen(true);
    } else {
      register = FinancialEntryRegister();
      await _startScreen(false);      
    }

    _setState(FinancialEntryState.loaded);    
  }

  //if there is a register r = true
  Future<void> _startScreen(bool r) async {
    await setType();
    if(r){
      btDelete = true;
      btUpdate = true;      
      await _setDataScreen();
    }else{
      btInclude = true;
      btClear = true;      
      await setNextId();
    }   
  }

  Future<void> setType() async {
    try {
      AccountConnect _account = AccountConnect();
      _account_credit = await _account.getDataType('C');
      _account_debit = await _account.getDataType('D');
      changeType(isCredit);
    } catch (e) {
      debugPrint('Erro SetType -> $e');
    }
  }

  Future<void> setNextId() async {
    tdcId.text = await FinancialEntryConnect().getNextId();
  }
  
  void save(BuildContext context) async {
    try {
      //register
      if(_getDataScreen(context)==false){
        return;
      }

      FinancialEntryConnect().setData(register);

      message.simple(context, "", "LANÇAMENTO CADASTRADO COM SUCESSO!");

      clean();
    } catch (e) {
      message.simple(context, "", "ERRO: $e");
    }
  }

  bool _getDataScreen(BuildContext context){
    try{
      //check fields
      String errorRegister = '';
      if (tdcDescription.text == '') {
        errorRegister = errorRegister + 'Descrição inválida\n';
      }
      if (errorDate != null || tdcDate.text == '') {
        errorRegister = errorRegister + 'Data inválida\n';
      }
      if (errorValue != null || tdcValue.text == '') {
        errorRegister = errorRegister + 'Valor inválido\n';
      }
      if (errorRegister != '') {
        message.simple(context, '', errorRegister);
        return false;
      }
      register = FinancialEntryRegister();
      register.id = int.parse(tdcId.text);
      if (isCredit) {
        register.accountId = AccountConnect.getID(_account_credit!, typeValue);
      } else {
        register.accountId = AccountConnect.getID(_account_debit!, typeValue);
      }
      register.description = tdcDescription.text;
      register.date = convert.StringToDatetime(tdcDate.text);
      register.value = convert.currencyToDouble(tdcValue.text);
      return true;
    }catch(e){
      debugPrint('ERRO GETDATA -> $e');     
      return false;
    }    
  }

  Future<void> _setDataScreen() async{
    try{
      tdcId.text = register.id.toString();

      //check account ref register
      List<AccountRegister>? a = _account_debit?.where((i) => i.id == register.accountId).toList();
      if(a!.isEmpty){
         a = _account_credit?.where((i) => i.id == register.accountId).toList();
      }

      isCredit = a![0].credit!;

      await changeType(isCredit);

      typeValue = a[0].description!;
      tdcDescription.text = register.description;
      tdcDate.text = convert.DatetimeToDateBr(register.date);
      tdcValue.text = convert.doubleToCurrencyBR(register.value);
    }catch(e){
      debugPrint("ERRO _SETDATASCREEN -> $e");
    }
  }

  void clean() {
    tdcDate.text = '';
    tdcDescription.text = '';
    tdcValue.text = '';
    isCredit = true;
    setNextId();
  }

  void delete(BuildContext context) async{
      bool confirm = await message.confirm(context,"CONFIRMA EXCLUSÃO?",
      "ID: " + register.id.toString() +
      "DATA: " + convert.DatetimeToDateBr(register.date) + "\n" 
      + register.description.toUpperCase()
      + "\nVALOR: "
      + convert.doubleToCurrencyBR(register.value)
    );
    if(confirm){
      FinancialEntryConnect().delete(register);
      clean();
    }
  }

  void update(BuildContext context){
    if(_getDataScreen(context)==false){
        return;
    }
    FinancialEntryConnect().update(register);
    message.simple(context, "", "LANÇAMENTO ATUALIZADO COM SUCESSO!");
  }

  Future<void> changeType(bool isCredit) async {
    try {
      this.isCredit = isCredit;
      typeList.clear();
      if (isCredit) {
        typeList =
            _account_credit!.map((element) => element.description!).toList();
      } else {
        typeList =
            _account_debit!.map((element) => element.description!).toList();
      }
      typeValue = typeList.first;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ChangeType -> $e');
    }
  }

}