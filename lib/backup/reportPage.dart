
/*import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/register/accountRegister.dart';
import 'package:firebase_write/register/financialEntryRegister.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';

import '../help/mask.dart';
import '../help/valid.dart';

// ignore: camel_case_types
class reportPageBackup extends StatefulWidget{
  const reportPageBackup({Key? key}) : super(key: key);

   @override
  _MyHomePageState createState() => _MyHomePageState();
}

  // ignore: non_constant_identifier_names
  class _MyHomePageState extends State<reportPageBackup> {
    late List<_tempRowRegister> registers = <_tempRowRegister>[];

    final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 10),
    () => 'Data Loaded',
  );

    List<String> periodTitle = <String>[];

    final TextEditingController _tecDateStart = TextEditingController(text: '');
    final TextEditingController _tecDateEnd = TextEditingController(text: '');
    late PaginationController _paginationController;

    String? _errorDateStart;
    String? _errorDateEnd;

    static const List<String> periodList = <String>['Diário', 'Semanal', 'Mensal', 'Anual'];
    String periodValue = periodList.first;

  _MyHomePageState(){    
    _tecDateStart.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _tecDateEnd.text = DateFormat('dd/MM/yyyy').format(DateTime.now().add(const Duration(days: 2)));      
    _periodTitle();
    _getAccount();    
  }

  _getAccount() async{
    AccountRegister a = AccountRegister();
    List<AccountRegister>? account = await a.getData();
   
    registers.clear();
    for(int i=0;i<account!.length;i++){
      _tempRowRegister temp = _tempRowRegister(account[i],periodTitle.length);
      registers.add(temp);
    }
  }

  _periodTitle(){    
    periodTitle.clear();
    if(periodValue=="Diário"){
      DateTime d = convert.StringToDatetime(_tecDateStart.text);
      int periodLenght = convert.StringToDatetime(_tecDateEnd.text)
      .difference(d).inDays;
      for(int i=0;i<periodLenght+1;i++){
        periodTitle.add(d.year.toString() +
         "\n" + convert.DatetimeMonthBr(d.month) + 
         "\n" + d.day.toString());
        d = d.add(const Duration(days: 1));        
      }
    }
  }
  
  _typeTitle(){
    List<String> periodList = <String>[];
    if(periodValue=="Diário"){
      DateTime d = convert.StringToDatetime(_tecDateStart.text);
      int periodLenght = convert.StringToDatetime(_tecDateEnd.text)
      .difference(d).inDays;
      for(int i=0;i<periodLenght+1;i++){
        periodList.add(d.year.toString() +
         "\n" + convert.DatetimeMonthBr(d.month) + 
         "\n" + d.day.toString());
        d = d.add(const Duration(days: 1));        
      }
    }
    return periodList;
  }

  Future<String> _getRegister() async {
    try{
      _periodTitle();
      _getAccount();
      FinancialEntryRegister r = FinancialEntryRegister();
      List<FinancialEntryRegister>? reg = await r.getDataGapDate(_tecDateStart.text,_tecDateEnd.text);
      int positionArray = 0;

      if(periodValue=="Diário"){
        DateTime start = convert.StringToDatetime(_tecDateStart.text);
        DateTime end = convert.StringToDatetime(_tecDateEnd.text);

        while(!start.isAfter(end)){
          for(int i=0;i<reg!.length;i++){
            if(reg[i].date.isAfter(start)){
              break;
            }else if(reg[i].date.isBefore(start)){
              continue;
            }
            for(int j=0;j<registers.length;j++){
              if(reg[i].accountId==registers[j].account.id){
                registers[j].include(reg[i],positionArray);
              }
            }
          }

          start = start.add(const Duration(days: 1));
          positionArray++;
        }
      }

      _paginationController = PaginationController(
        rowCount: registers.length,
        rowsPerPage: 10,
      );

      return '';
    }catch(e){
      print('ERRO _GETREGISTER -> $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("RELATÓRIO"),
      ),
      body: Padding(
        padding:const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[            
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget> [
                  _period(),
                  const SizedBox(width: 30,),
                  _dateStart(),
                  const SizedBox(width: 30,),
                  _dateEnd()                  
                ]
              ),
            ),  
            const SizedBox(height: 20,), 
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _panel(context),
                  ),
                ]
              )
            )         
          ],
        ),
      ),
    );
  }

  Widget _dateStart(){    
    return Flexible(
      child: TextField(
        controller: _tecDateStart,
        keyboardType: TextInputType.number,
        inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            mask.maskDate,
          ],
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            icon: const Icon(Icons.calendar_today_rounded),
            errorText: _errorDateStart,
            labelText: "Data Inicial"
        ),
        onTap: () async {
          DateTime? pickeddate = await showDatePicker(
            context: context, 
            initialDate: DateTime.now(),
            firstDate: DateTime(2000), 
            lastDate: DateTime(2100));
          if (pickeddate != null){
            setState(() {
              _tecDateStart.text =  DateFormat('dd/MM/yyyy').format(pickeddate);
            });
            }
          },
        onChanged: (value) {
          setState(() {
            _errorDateStart = valid.checkDate(_tecDateStart.text);
          });
        },
      ),
    );
  }

  Widget _dateEnd(){    
    return Flexible(
      child: TextField(
        controller: _tecDateEnd,
        keyboardType: TextInputType.number,
        inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            mask.maskDate,
          ],
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            icon: const Icon(Icons.calendar_today_rounded),
            errorText: _errorDateEnd,
            labelText: "Data Final"
        ),
        onTap: () async {
          DateTime? pickeddate = await showDatePicker(
            context: context, 
            initialDate: DateTime.now(),
            firstDate: DateTime(2000), 
            lastDate: DateTime(2100));
          if (pickeddate != null){
            setState(() {
              _tecDateEnd.text =  DateFormat('dd/MM/yyyy').format(pickeddate);
              });
            }
          },
        onChanged: (value) {
          setState(() {
            _errorDateEnd = valid.checkDate(_tecDateEnd.text);
          });
        },
      ),
    );
  }

  Widget _period() {
    return DropdownButton<String>(
      value: periodValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          periodValue = value!;
        });
      },
      items: periodList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  FutureBuilder<String> _panel(BuildContext context){
    return FutureBuilder<String>(
    future: _getRegister(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          children = <Widget>[
            Flexible(
              child: ScrollableTableView(
                paginationController: _paginationController,
                columns: _columnPanel(),
                rows: _rowsPanel(),
              ),
            ),
          ];
        } else if (snapshot.hasError) {
          children = <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            ),
          ];
        } else {
          children = const <Widget>[
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }

  List<TableViewColumn> _columnPanel(){
    List<TableViewColumn> columns = <TableViewColumn>[];

    for(int i=0;i<periodTitle.length;i++){
      columns.add(
        TableViewColumn(
          width: 80,     
          labelFontSize: 11.5,
          label: periodTitle[i],
        )
      );
    }

    return columns;
  }

  List<TableViewRow> _rowsPanel(){
    List<TableViewRow> rows = <TableViewRow>[];   

    for(int i=0;i<registers.length;i++){
      List<TableViewCell> cell = <TableViewCell>[]; 
      for(int j=0;j<registers[i].register.length;j++){
        cell.add(
          TableViewCell(
            child: TextButton(
                child: Text(registers[i].register[j].sum.toString()),
                onPressed: () {},              
              ),
          )
        );
      }
      rows.add(
        TableViewRow(
          height: 50,
          cells: cell,
          
        )
      );
    }
    return rows;
  }

}

// ignore: camel_case_types
class _tempRowRegister{
  late List<_tempCellRegister> register = <_tempCellRegister>[];
  late AccountRegister account;

  _tempRowRegister(this.account,int col){
    for(int i=0;i<col;i++){
      _tempCellRegister c = _tempCellRegister();
      register.add(c);
    }
  }

  include(FinancialEntryRegister f,int positionArray){
    register[positionArray].include(f);
  }

}

// ignore: camel_case_types
class _tempCellRegister{
  late double sum = 0;
  late List<FinancialEntryRegister> cellRegister = <FinancialEntryRegister>[];

  bool include(FinancialEntryRegister f){
    sum += f.value;
    cellRegister.add(f);
    return true;
  }

}*/