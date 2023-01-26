import 'package:firebase_write/custom/widgets/customCurrencyTextField.dart';
import 'package:firebase_write/custom/widgets/customDateTextField.dart';
import 'package:firebase_write/custom/widgets/customDropDown.dart';
import 'package:firebase_write/custom/widgets/customTextField.dart';
import 'package:firebase_write/database.dart/connection/accountConnect.dart';
import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/help/message.dart';
import 'package:firebase_write/database.dart/register/accountRegister.dart';
import 'package:firebase_write/database.dart/register/financialEntryRegister.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

// ignore: must_be_immutable
class FinancialEntryPage extends StatefulWidget {
  const FinancialEntryPage({Key? key, this.register}) : super(key: key);

  final FinancialEntryRegister? register;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FinancialEntryPage> {
  late FinancialEntryRegister register;
  bool isLoading = true;

  // ignore: non_constant_identifier_names
  late List<AccountRegister>? _account_credit;
  // ignore: non_constant_identifier_names
  late List<AccountRegister>? _account_debit;

  late List<String> typeList = <String>[' '];
  late String typeValue = typeList.first;

  String? _errorValue;
  String? _errorDate;

  bool _isCredit = true;

  final TextEditingController _tdcId = TextEditingController(text: '');
  final TextEditingController _tdcDescription = TextEditingController(text: '');
  final TextEditingController _tdcDate = TextEditingController(text: '');
  final TextEditingController _tdcValue = TextEditingController(text: '');

  bool _btInclude = false,
      _btDelete = false,
      _btUpdate = false,
      _btClear = false;

  @override
  void initState() {
    setIsloading(true);

    if (widget.register != null) {
      register = widget.register!;
      _startScreen(true);
    } else {
      register = FinancialEntryRegister();
      _startScreen(false);      
    }

    super.initState();
  }

  void setIsloading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  //if there is a register r = true
  void _startScreen(bool r) async {
    await setType();
    if(r){
      _btDelete = true;
      _btUpdate = true;      
      await _setDataScreen();
    }else{
      _btInclude = true;
      _btClear = true;      
      await setNextId();
    }   
    setIsloading(false);
  }

  Future<void> setType() async {
    try {
      AccountConnect _account = AccountConnect();
      _account_credit = await _account.getDataType('C');
      _account_debit = await _account.getDataType('D');
      changeType();
    } catch (e) {
      print('Erro SetType -> $e');
    }
  }

  Future<void> setNextId() async {
    _tdcId.text = await register.getNextId();
  }

  @override
  void dispose() {
    _tdcId.dispose();
    _tdcDescription.dispose();
    _tdcDate.dispose();
    _tdcValue.dispose();
    super.dispose();
  }

  void save() async {
    try {
      //register
      if(_getDataScreen()==false){
        return;
      }
      register.setData();

      message.simple(context, "", "LANÇAMENTO CADASTRADO COM SUCESSO!");

      _clean();
    } catch (e) {
      message.simple(context, "", "ERRO: $e");
    }
  }

  bool _getDataScreen(){
    try{
      //check fields
      String errorRegister = '';
      if (_tdcDescription.text == '') {
        errorRegister = errorRegister + 'Descrição inválida\n';
      }
      if (_errorDate != null || _tdcDate.text == '') {
        errorRegister = errorRegister + 'Data inválida\n';
      }
      if (_errorValue != null || _tdcValue.text == '') {
        errorRegister = errorRegister + 'Valor inválido\n';
      }
      if (errorRegister != '') {
        message.simple(context, '', errorRegister);
        return false;
      }
      register = FinancialEntryRegister();
      register.id = int.parse(_tdcId.text);
      if (_isCredit) {
        register.accountId = AccountConnect.getID(_account_credit!, typeValue);
      } else {
        register.accountId = AccountConnect.getID(_account_debit!, typeValue);
      }
      register.description = _tdcDescription.text;
      register.date = convert.StringToDatetime(_tdcDate.text);
      register.value = convert.currencyToDouble(_tdcValue.text);
      return true;
    }catch(e){
      print('ERRO GETDATA -> $e');     
      return false;
    }    
  }

  Future<void> _setDataScreen() async{
    try{
      _tdcId.text = register.id.toString();

      //check account ref register
      List<AccountRegister>? a = _account_debit?.where((i) => i.id == register.accountId).toList();
      if(a!.isEmpty){
         a = _account_credit?.where((i) => i.id == register.accountId).toList();
      }

      _isCredit = a![0].credit!;

      await changeType();

      typeValue = a[0].description!;
      _tdcDescription.text = register.description;
      _tdcDate.text = convert.DatetimeToDateBr(register.date);
      _tdcValue.text = convert.doubleToCurrencyBR(register.value);
    }catch(e){
      print("ERRO _SETDATASCREEN -> $e");
    }
  }

  void _clean() {
    _tdcDate.text = '';
    _tdcDescription.text = '';
    _tdcValue.text = '';
    _isCredit = true;
    setNextId();
  }

  void _delete() async{
      bool confirm = await message.confirm(context,"CONFIRMA EXCLUSÃO?",
      "ID: " + register.id.toString() +
      "DATA: " + convert.DatetimeToDateBr(register.date) + "\n" 
      + register.description.toUpperCase()
      + "\nVALOR: "
      + convert.doubleToCurrencyBR(register.value)
    );
    if(confirm){
      register.delete();
      _clean();
    }
  }

  void _update(){
    if(_getDataScreen()==false){
        return;
    }
    register.update();
    message.simple(context, "", "LANÇAMENTO ATUALIZADO COM SUCESSO!");
  }

  Future<void> changeType() async {
    try {
      typeList.clear();
      if (_isCredit) {
        typeList =
            _account_credit!.map((element) => element.description!).toList();
      } else {
        typeList =
            _account_debit!.map((element) => element.description!).toList();
      }
      setState(() {
        typeValue = typeList.first;
      });
    } catch (e) {
      print('Erro ChangeType -> $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FloatingActionButton(
          elevation: 0,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          child: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop("update");          
          },
        ),
        centerTitle: true,
        title: const Text("LANÇAMENTO FINANCEIRO"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: CustomTextField(
                              controller: _tdcId,
                              icon: Icons.article_rounded,
                              enabled: false,
                              label: "Id",
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          _credit(),
                        ]),                       
                    CustomDropDown(
                      list: typeList,
                      selected: typeValue,
                      icon: Icons.account_balance,
                      add: () {
                      },                    
                      change: (value) {
                        setState(() {
                          typeValue=value;                          
                        });
                      },
                    ),
                    CustomTextField(
                      controller: _tdcDescription,
                      label: 'Descrição',
                    ),
                    CustomDateTextField(
                      controller: _tdcDate,
                    ),
                    CustomCurrencytextField(
                      controller: _tdcValue, 
                      errorText: _errorValue,
                    ),
                    _buttonRow(),
                  ]),
            ),
    );
  }

  Widget _credit() {
    return FlutterSwitch(
      width: 180.0,
      height: 50.0,
      valueFontSize: 25.0,
      toggleSize: 45.0,
      value: _isCredit,
      borderRadius: 30.0,
      padding: 8.0,
      activeText: "Crédito",
      inactiveText: "Débito",
      activeColor: Colors.green,
      inactiveColor: Colors.red,
      showOnOff: true,
      onToggle: (val) {
        setState(() {
          _isCredit = val;
          changeType();
        });
      },
    );
  }

  Widget _buttonRow() {
    List<Widget> buttons = <Widget>[];
    if (_btUpdate) {
      buttons.add(_buttonUpdate());
    }
    if (_btDelete) {
      buttons.add(_buttonDelete());
    }
    if (_btInclude) {
      buttons.add(_buttonInclude());
    }
    if (_btClear) {
      buttons.add(_buttonClean());
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }

  Widget _buttonInclude() {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      onPressed: () {
        save();
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _buttonUpdate() {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      onPressed: () {
        _update();
      },
      child: const Icon(Icons.update),
    );
  }

  Widget _buttonDelete() {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      onPressed: () {
        _delete();
      },
      child: const Icon(Icons.delete),
    );
  }

  Widget _buttonClean() {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      onPressed: () {
        _clean();
      },
      child: const Icon(Icons.cleaning_services),
    );
  }

}
