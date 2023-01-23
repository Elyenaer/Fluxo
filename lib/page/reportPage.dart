
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/help/funcDate.dart';
import 'package:firebase_write/page/listFinancialRegisterPage.dart';
import 'package:firebase_write/database.dart/register/accountRegister.dart';
import 'package:firebase_write/database.dart/register/financialEntryRegister.dart';
import 'package:firebase_write/settings/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';

import '../help/mask.dart';
import '../help/valid.dart';

// ignore: camel_case_types, must_be_immutable
class reportPage extends StatefulWidget{
  const reportPage({
    Key? key,
  }) : super(key: key);

   @override
  _MyHomePageState createState() => _MyHomePageState();
}

  // ignore: non_constant_identifier_names
  class _MyHomePageState extends State<reportPage> {
    late List<_tempRowRegister> registers = <_tempRowRegister>[];
    
    @override
    //late BuildContext context;

    // ignore: override_on_non_overriding_member
    late final List<String> _columnTitle = <String>[];
    static const double _columnWidth = 100;
    static const double _rowHeight = 50;
    

    final TextEditingController _tecDateStart = TextEditingController(text: '');
    final TextEditingController _tecDateEnd = TextEditingController(text: '');
    late DateTime start,end;
    late double _scalePanel = 1.0;

    String? _errorDateStart;
    String? _errorDateEnd;

    static const List<String> periodList = <String>['Diário', 'Semanal', 'Mensal', 'Anual'];
    String periodValue = periodList.first;

    bool _isLoading = true;

  @override
  void initState(){
    //context = widget.context;
    _tecDateStart.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _tecDateEnd.text = DateFormat('dd/MM/yyyy').format(DateTime.now().add(const Duration(days: 2)));      
    _getRegister();
    super.initState();
  }

  void _setLoading(bool isLoading){
    setState(() {
      _isLoading = isLoading;      
    });    
  }

  _getAccount() async{
    AccountRegister a = AccountRegister();
    List<AccountRegister>? account = await a.getData();
   
    registers.clear();
    for(int i=0;i<account!.length;i++){
      _tempRowRegister temp = _tempRowRegister(account[i],_columnTitle.length);
      registers.add(temp);
    }
  }

  _getColumnTitle(){    
    _columnTitle.clear();
    DateTime d;
    if(periodValue=="Diário"){
      start = convert.StringToDatetime(_tecDateStart.text);
      end = convert.StringToDatetime(_tecDateEnd.text);
      d = start;
      int periodLenght = end.difference(d).inDays;
      for(int i=0;i<periodLenght+1;i++){
        _columnTitle.add(d.year.toString() +
         "\n" + convert.DatetimeMonthBr(d.month,true) + 
         "\n" + d.day.toString());
        d = d.add(const Duration(days: 1));        
      }
    }
    else if(periodValue=="Semanal"){
      start = funcDate.getWeekday(
        convert.StringToDatetime(_tecDateStart.text),false,6);
      end = funcDate.getWeekday(
        convert.StringToDatetime(_tecDateEnd.text),true,6);    
      d = start;
      while(!d.isAfter(end)){
        _columnTitle.add(convert.DatePeriod(d, periodValue));    
        d = d.add(const Duration(days: 7));              
      }
    }else if(periodValue=="Mensal"){
      start = funcDate.getMonth(
        convert.StringToDatetime(_tecDateStart.text),true);
      end = funcDate.getMonth(
        convert.StringToDatetime(_tecDateEnd.text),false);
      d = start;
      while(!d.isAfter(end)){
        _columnTitle.add(convert.DatePeriod(d, periodValue));    
        d = funcDate.addMonth(d);  
      }
    }else{
      start = funcDate.getYear(
        convert.StringToDatetime(_tecDateStart.text),true);
      end = funcDate.getYear(
        convert.StringToDatetime(_tecDateEnd.text),false);
      d = start;
      while(!d.isAfter(end)){
        _columnTitle.add(convert.DatePeriod(d, periodValue));    
        d = funcDate.addYear(d);  
      }
    }
  }
  
  _getRegister() async {
    try{
      _setLoading(true);
      _getColumnTitle();
      _getAccount();
      FinancialEntryRegister r = FinancialEntryRegister();
      List<FinancialEntryRegister>? reg = await r.getDataGapDate(start,end);
      int positionArray = 0;
      DateTime d = start;
      DateTime d2; //interval from d to d2

      while(!d.isAfter(end)){
        if(periodValue=="Diário"){
          d2 = d;
        }else if(periodValue=="Semanal"){
          d2 = d.add(const Duration(days: 6));
        }else if(periodValue=="Mensal"){
          d2 = funcDate.getMonth(d,false);
        }else{
          d2 = funcDate.getYear(d,false);
        }

        for(int i=0;i<reg!.length;i++){
          if(reg[i].date.isAfter(d2)){
            break;
          }else if(reg[i].date.isBefore(d)){
            continue;
          }
          for(int j=0;j<registers.length;j++){
            if(reg[i].accountId==registers[j].account.id){
              registers[j].include(reg[i],positionArray);
            }
          }
        }

        if(periodValue=="Diário"){
          d = d.add(const Duration(days: 1));
        }else if(periodValue=="Semanal"){
          d = d.add(const Duration(days: 7));
        }else if(periodValue=="Mensal"){
          d = funcDate.addMonth(d);
        }else{
          d = DateTime(d.year+1,1,1);
        }    

        positionArray++;
      }
      _setLoading(false);
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
              child: _isLoading
              ?  const Center(child: CircularProgressIndicator())
              :Row(
                children: [
                  Expanded(
                    child: _panel(),
                  ),
                ]
              )
            ),
            _sliderScale()       
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
              _tecDateStart.text =  DateFormat('dd/MM/yyyy').format(pickeddate);
              _getRegister();
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
            _tecDateEnd.text =  DateFormat('dd/MM/yyyy').format(pickeddate);
            _getRegister();
          }
        },          
        onChanged: (value) {
          _errorDateEnd = valid.checkDate(_tecDateEnd.text);
          if(_errorDateEnd==null){
            _getRegister();
          }
        },
      ),
    );
  }

  Widget _period() {
    return DropdownButton<String>(
      value: periodValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.grey,
      ),
      onChanged: (String? value) {
        periodValue = value!;
        _getRegister();
      },
      items: periodList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _panel(){
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 1.5,
            ),
          ),
        height: MediaQuery.of(context).size.height-200,        
        child: HorizontalDataTable(
          leftHandSideColumnWidth: (_columnWidth+20)*_scalePanel,
          rightHandSideColumnWidth: _columnWidth*(_columnTitle.length)*_scalePanel,
          isFixedHeader: true,
          headerWidgets: _titleItem(),
          leftSideItemBuilder:  _rowTitle,
          rightSideItemBuilder: _rowPanel,
          itemCount: registers.length,
          rowSeparatorWidget: const Divider(
            height: 1.0,
            thickness: 0.0,
          ),
        ),     
      );
  }

  // ignore: non_constant_identifier_names
  List<Widget> _titleItem() {    

    List<Widget> title = <Widget>[];

    title.add(Container(     
      color: Theme.of(context).scaffoldBackgroundColor,
      width: (_columnWidth+20) * _scalePanel,
      height: _rowHeight * _scalePanel,
      child: Transform.scale(
        scale: _scalePanel,
        child: FloatingActionButton(          
          elevation: 0.0,        
          onPressed: () {

          },      
          child: Icon(
            Icons.schema_outlined,
            color: Theme.of(context).primaryColor,
            ),
          backgroundColor: Colors.transparent,
        )
      )
    ));
    
    for(int i=0;i<_columnTitle.length;i++){
      title.add(
        Container(     
          color: Theme.of(context).appBarTheme.backgroundColor,
            child: AutoSizeText(
              _columnTitle[i], 
              textAlign: TextAlign.center,
              maxLines: 3,
              minFontSize: 1,
              style: TextStyle(
                color: Theme.of(context).appBarTheme.foregroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 15.0 * _scalePanel
              )
          ),
          width: _columnWidth * _scalePanel,
          height: _rowHeight * _scalePanel,
          alignment: Alignment.center,
          //color: Theme.of(context).appBarTheme.backgroundColor,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        )
      );
    }

    return title;
  }

  Widget _rowTitle(BuildContext context, int index) {

    return Center(
      child: Container(     
        color: _getBackgroundRowTitle(index,registers[index].account.credit),  
        child: AutoSizeText(
          registers[index].account.description,
          maxLines: 2,
          minFontSize: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0 * _scalePanel,
            color: Colors.white
          )
        ),
        height: _rowHeight * _scalePanel,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget _rowPanel(BuildContext context, int index) {

    Color backgroundColor;
    if(registers[index].account.credit){
      if(index % 2 == 0){
        backgroundColor = theme.backgroundEntryCredit1;
      // ignore: dead_code
      }else{
        backgroundColor = theme.backgroundEntryCredit2;
      }
    }else{
      if(index % 2 == 0){
        backgroundColor = theme.backgroundEntryDebt1;
      // ignore: dead_code
      }else{
        backgroundColor = theme.backgroundEntryDebt2;
      }
    }

    return Row(
      children: <Widget>[
        SizedBox(
          height: _rowHeight * _scalePanel,          
            child: Row(            
              children: _getRowsPanel(registers[index],backgroundColor),
            ),
          ),
      ],
    );
  }

  List<Widget> _getRowsPanel(_tempRowRegister r,Color backgroundColor){

    Color foregroundColor = theme.foregroundEntryDebt;
    if(r.account.credit){
      foregroundColor = theme.foregroundEntryCredit;
    }

    List<Widget> rows = <Widget>[];
    for(int i=0;i<r.register.length;i++){      

      rows.add(
        Container(
          width: _columnWidth *_scalePanel,
          height: _rowHeight * _scalePanel,
          color: backgroundColor,
          child: TextButton(       
            child: AutoSizeText(                            
              convert.doubleToCurrencyBR(r.register[i].sum),
              minFontSize: 1,
              maxLines: 1,
              style: TextStyle(
                color: foregroundColor,
                fontSize: 15.0 * _scalePanel            
              ),
            ),
            onPressed: () {
              final updateCheck = Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => 
                  ListFinancialRegisterPage(
                    backgroundTitle: _getBackgroundRowTitle(i,r.account.credit),
                    account: r.account,
                    title: _columnTitle[i],
                    start: start,
                    end: end,
                    registers: r.register[i].cellRegister,
                  )
                ),
              );
              updateCheck.then((value) {
                if(value=="update"){
                  setState(() { });
                }
              });
            },              
          ),
        ),
      );
    }    
    return rows;
  }

  Widget _sliderScale(){
    return Slider(
      value: _scalePanel,
      max: 3.0,
      min: 0.1,
      divisions: 29,
      label: convert.percent(_scalePanel,1.0,0),
      onChanged: (double value) {
        setState(() {
          _scalePanel = value;
        });
      },
    );
  }

  Color _getBackgroundRowTitle(int i,bool credit){
    if(!credit){
      if(i % 2 == 0){
        return theme.backgroundTitleDebt1;
      // ignore: dead_code
      }else{
        return theme.backgroundTitleDebt2;
      }
    }else{
      if(i == 0){
        return theme.backgroundTitleCredit1;
      // ignore: dead_code
      }else{
        return theme.backgroundTitleCredit2;
      }
    }
  }

  }

// ignore: camel_case_types
class _tempRowRegister{
  late List<_tempCellRegister> register = <_tempCellRegister>[];
  late AccountRegister account;

  _tempRowRegister(this.account,int col){
    for(int i=0;i<col;i++){
      _tempCellRegister c = _tempCellRegister(i);
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
  late int position;
  late List<FinancialEntryRegister> cellRegister = <FinancialEntryRegister>[];

  _tempCellRegister(this.position);

  bool include(FinancialEntryRegister f){
    sum += f.value;
    cellRegister.add(f);
    return true;
  }

}