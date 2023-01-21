import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/help/mask.dart';
import 'package:firebase_write/help/message.dart';
import 'package:firebase_write/help/valid.dart';
import 'package:firebase_write/database.dart/register/accountRegister.dart';
import 'package:firebase_write/database.dart/register/financialEntryRegister.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../Help/currencyPtBrInputFormatter.dart';

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
      AccountRegister _account = AccountRegister();
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

      clean();
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
        register.accountId = AccountRegister.getID(_account_credit!, typeValue);
      } else {
        register.accountId = AccountRegister.getID(_account_debit!, typeValue);
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

      _isCredit = a![0].credit;

      await changeType();

      typeValue = a[0].description;
      _tdcDescription.text = register.description;
      _tdcDate.text = convert.DatetimeToDateBr(register.date);
      _tdcValue.text = convert.doubleToCurrencyBR(register.value);
    }catch(e){
      print("ERRO _SETDATASCREEN -> $e");
    }
  }

  void clean() {
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
      clean();
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
            _account_credit!.map((element) => element.description).toList();
      } else {
        typeList =
            _account_debit!.map((element) => element.description).toList();
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
          child: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop("update");          
        },),
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
                          _id(),
                          const SizedBox(
                            width: 50,
                          ),
                          _credit(),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.account_balance,
                            size: 25,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          _type(),
                          const SizedBox(
                            width: 50,
                          ),
                          _buttonIncludeType(),
                        ]),
                    _description(),
                    _date(),
                    _value(),
                    _buttonRow(),
                  ]),
            ),
    );
  }

  Widget _id() {
    return Flexible(
      child: TextField(
        enabled: false,
        controller: _tdcId,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          icon: Icon(Icons.article_rounded),
          labelText: 'Id',
        ),
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

  Widget _type() {
    return Flexible(
      child: DropdownButton<String>(
        value: typeValue,
        icon: const Icon(Icons.arrow_drop_down),
        isExpanded: true,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? value) {
          typeValue = value!;
        },
        items: typeList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
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
        clean();
      },
      child: const Icon(Icons.cleaning_services),
    );
  }

  Widget _description() {
    return TextField(
      controller: _tdcDescription,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(Icons.text_fields),
        labelText: 'Descrição',
      ),
    );
  }

  Widget _date() {
    return TextField(
      controller: _tdcDate,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        mask.maskDate,
      ],
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          icon: const Icon(Icons.calendar_today_rounded),
          errorText: _errorDate,
          labelText: "Data"),
      onTap: () async {
        DateTime? pickeddate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100));
        if (pickeddate != null) {
          setState(() {
            _tdcDate.text = DateFormat('dd/MM/yyyy').format(pickeddate);
          });
        }
      },
      onChanged: (value) {
        _errorDate = valid.checkDate(_tdcDate.text);
      },
    );
  }

  Widget _value() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 60),
      child: TextField(
        controller: _tdcValue,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          icon: const Icon(Icons.monetization_on),
          labelText: 'Valor',
          errorText: _errorValue,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CurrencyPtBrInputFormatter()
        ],
        onChanged: (value) {
          try {
            if (convert.currencyToDouble(value) == 0) {
              _errorValue = 'Valor Inválido';
            } else {
              _errorValue = null;
            }
          } catch (e) {
            _errorValue = 'Valor Inválido';
          }
        },
      ),
    );
  }

  Widget _buttonIncludeType() {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      onPressed: () {},
      child: const Icon(Icons.add),
    );
  }
}
