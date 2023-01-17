
import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/page/financialEntryPage.dart';
import 'package:firebase_write/register/accountRegister.dart';
import 'package:firebase_write/register/financialEntryRegister.dart';
import 'package:firebase_write/settings/formats.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';

import '../help/mask.dart';
import '../help/valid.dart';

// ignore: camel_case_types
class reportPage extends StatefulWidget{
  const reportPage({Key? key}) : super(key: key);

   @override
  _MyHomePageState createState() => _MyHomePageState();
}

  // ignore: non_constant_identifier_names
  class _MyHomePageState extends State<reportPage> {
    late List<_tempRowRegister> registers = <_tempRowRegister>[];

    late final List<Widget> _columnTitle = <Widget>[];
    static const double _columnWidth = 100;
    static const double _rowHeight = 50;
    

    final TextEditingController _tecDateStart = TextEditingController(text: '');
    final TextEditingController _tecDateEnd = TextEditingController(text: '');
    late DateTime start,end;

    String? _errorDateStart;
    String? _errorDateEnd;

    static const List<String> periodList = <String>['Diário', 'Semanal', 'Mensal', 'Anual'];
    String periodValue = periodList.first;

  _MyHomePageState(){    
    _tecDateStart.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _tecDateEnd.text = DateFormat('dd/MM/yyyy').format(DateTime.now().add(const Duration(days: 2)));      
    _getColumnTitle();
    _getAccount();    
  }

  _getAccount() async{
    AccountRegister a = AccountRegister();
    List<AccountRegister>? account = await a.getData();
   
    registers.clear();
    for(int i=0;i<account!.length;i++){
      _tempRowRegister temp = _tempRowRegister(account[i],_columnTitle.length-1);
      registers.add(temp);
    }
  }

  _getColumnTitle(){    
    _columnTitle.clear();
    _columnTitle.add(_titleItem(""));
    DateTime d;
    if(periodValue=="Diário"){
      start = convert.StringToDatetime(_tecDateStart.text);
      end = convert.StringToDatetime(_tecDateEnd.text);
      d = start;
      int periodLenght = end.difference(d).inDays;
      for(int i=0;i<periodLenght+1;i++){
        _columnTitle.add(_titleItem(d.year.toString() +
         "\n" + convert.DatetimeMonthBr(d.month) + 
         "\n" + d.day.toString()));
        d = d.add(const Duration(days: 1));        
      }
    }
    else if(periodValue=="Semanal"){
      start = convert.getWeekday(
        convert.StringToDatetime(_tecDateStart.text),false,5);
      end = convert.getWeekday(
        convert.StringToDatetime(_tecDateEnd.text),true,5);    
      d = start;
      while(!d.isAfter(end)){
        _columnTitle.add(_titleItem(convert.DatePeriod(d, periodValue)));    
        d = d.add(const Duration(days: 7));              
      }
    }else if(periodValue=="Mensal"){
      start = convert.getMonth(
        convert.StringToDatetime(_tecDateStart.text),true);
      end = convert.getMonth(
        convert.StringToDatetime(_tecDateEnd.text),true);
      d = start;
      while(!d.isAfter(end)){
        _columnTitle.add(_titleItem(convert.DatePeriod(d, periodValue)));    
        d = DateTime(d.year+1);     
      }
    }

  }

  // ignore: non_constant_identifier_names
  _titleItem(String label) {
    return Container(
      child: Text(
        label, 
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )
        ),
      color: Colors.black,
      width: _columnWidth,
      height: 56,
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
    );
  }
  
  Future<String> _getRegister() async {
    try{
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
          d2 = convert.getMonth(d,false);
        }else{
          d2 = convert.getYear(d,false);
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
          d = convert.addMonth(d);
        }else{
          d = DateTime(d.year+1,1,1);
        }    

        positionArray++;
      }
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
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent)
                ),
              child: HorizontalDataTable(
                leftHandSideColumnWidth: 100,
                rightHandSideColumnWidth: _columnWidth*(_columnTitle.length-1),
                isFixedHeader: true,
                headerWidgets: _columnTitle,
                leftSideItemBuilder: _rowTitle,
                rightSideItemBuilder: _rowPanel,
                itemCount: registers.length,
                rowSeparatorWidget: const Divider(
                  color: Colors.black54,
                  height: 1.0,
                  thickness: 0.0,
                ),
              ),
              height: MediaQuery.of(context).size.height-200,
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

  Widget _rowTitle(BuildContext context, int index) {
    return Container(
      child: Text(
          registers[index].account.description,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )
        ),
      color: Colors.grey,
      height: _rowHeight,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _rowPanel(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        SizedBox(
          height: _rowHeight,
          child: Row(            
            children: _getRowsPanel(registers[index]),
          )
        )
      ],
    );
  }

  List<Widget> _getRowsPanel(_tempRowRegister r){
    List<Widget> rows = <Widget>[];
    for(int i=0;i<r.register.length;i++){
      rows.add(
        SizedBox(
          width: _columnWidth,
          child: TextButton(
            child: Text(convert.doubleToCurrencyBR(r.register[i].sum)),
            onPressed: () {
              _showRegisters(context, r.register[i]);
            },              
          ),
        ),
      );
    }    
    return rows;
  }

  Future<void> _showRegisters(BuildContext context,_tempCellRegister r) {
    
    List<Widget> containerRegisters = <Widget>[];
    for(int i=0;i<r.cellRegister.length;i++){
      if(i>0){
        containerRegisters.add(const SizedBox(height: 10,));
      }
      containerRegisters.add(_showRegister(r.cellRegister[i]));      
    }

    return showDialog<void>(      
      context: context,
      builder: (BuildContext context) {
        return Material(
        type: MaterialType.transparency,
          child: Column(
            children: [
              _showRegisterTittle(_columnTitle[r.position]),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: containerRegisters,
                ),
              ),
            ],   
          ), 
        );        
      }
    );
  }

  Widget _showRegisterTittle(Widget title){
    return Container(
      color: const Color.fromARGB(255, 195, 212, 220),
      height: 60,
      padding: const EdgeInsets.fromLTRB(10,10,10,0),
      child: Center(
        child: Row(
          verticalDirection: VerticalDirection.up,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Transform.scale(
              alignment: Alignment.centerLeft,
              scale: 0.5,
              child: FloatingActionButton(
                child: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Expanded(
              child:Center(
                child: title
              ), 
            ),   
            Transform.scale(
              alignment: Alignment.centerRight,
              scale: 0.5,
              child: FloatingActionButton(
                child: const Icon(Icons.addchart_outlined),                                
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => 
                      const FinancialEntryPage()),
                  );                   
                },
              ),
            ),
          ],
        )  
      ),    
    );
  }

  Widget _showRegister(FinancialEntryRegister r){
    return Container(
      height: 85,
      padding: const EdgeInsets.fromLTRB(10,10,10,0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 225, 210, 210),
        border: Border.all(width: 2, color: Colors.blueGrey),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ), 
      child: Center(
        child: Column(
          children: [
            Row(
              verticalDirection: VerticalDirection.up,
              children: [
                formats.standard(convert.DatetimeToDateBr(r.date)),
                const SizedBox(width: 20,),
                Expanded(
                  child: formats.standard(r.description),              
                ), 
                const SizedBox(width: 20,),
                formats.standard(convert.doubleToCurrencyBR(r.value))
              ],
            ),   
            Transform.scale(
              alignment: Alignment.centerRight,
              scale: 0.5,
              child:Row(
                verticalDirection: VerticalDirection.up,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    child: const Icon(Icons.edit),                                
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => 
                          FinancialEntryPage(register: r,)),
                      );              
                    },
                  ),
                  const SizedBox(width: 10,),
                  FloatingActionButton(
                    child: const Icon(Icons.delete),
                    onPressed: () {
                                            
                    },
                  ),
                ],
              ),
            ),
            /*Expanded(
              child: Container(
                height: 10,
                width: 1000,
                color:Colors.black12,
              ),
            ),*/
          ],
        )  
      ),    
    );
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