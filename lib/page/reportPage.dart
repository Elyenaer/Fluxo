
import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/register/financialEntryRegister.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';

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

    var products = [
  {
    "product_id": "PR1000",
    "product_name": "KFC Chicken",
  },
  {
    "product_id": "PR1001",
    "product_name": "Italian Pizza",
  }
];

    var many_products = [
  {
    "product_id": "PR1000",
    "product_name": "KFC Chicken",
  },
  {
    "product_id": "PR1001",
    "product_name": "Italian Pizza",
  }
];

    final TextEditingController _tecDateStart = TextEditingController(text: '');
    final TextEditingController _tecDateEnd = TextEditingController(text: '');
    late final PaginationController _paginationController;

    String? _errorDateStart;
    String? _errorDateEnd;

    static const List<String> periodList = <String>['Diário', 'Semanal', 'Mensal', 'Anual'];
    String periodValue = periodList.first;

  _MyHomePageState(){
    _paginationController = PaginationController(
      rowCount: many_products.length,
      rowsPerPage: 10,
    );
    _tecDateStart.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _tecDateEnd.text = DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: 10)));      
  }

  _periodTitle(){
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

  _typeTitle(){

    
    
  }

  _getRegister() async {
    FinancialEntryRegister r = FinancialEntryRegister();
    List<FinancialEntryRegister>? reg = await r.getDataGapDate(_tecDateStart.text,_tecDateEnd.text);
    


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
                    child: _panel(context)
                  )
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

  /*
  Widget _panel(BuildContext context) {
    _getRegister();
    List<String> columnTitle = _periodTitle();
    var columns = columnTitle;
    return ScrollableTableView(
      paginationController: _paginationController,
      columns: columns.map((column) {
        return TableViewColumn(     
          width: 80,     
          labelFontSize: 11.5,
          label: column,
        );
      }).toList(),
      rows: many_products.map((product) {
        return TableViewRow(
          height: 60,
          cells: columns.map((column) {
            return TableViewCell(
              child: Text(product[column] ?? ""),
            );
          }).toList(),
        );
      }).toList(),
    );
  }*/

  Widget _panel(BuildContext context) {
    //_getRegister();
    List<String> columnTitle = _periodTitle();
    var columns = columnTitle;
    return ScrollableTableView(
      paginationController: _paginationController,
      columns: columns.map((column) {
        return TableViewColumn(     
          width: 80,     
          labelFontSize: 11.5,
          label: column,
        );
      }).toList(),
      rows: many_products.map((product) {
        return TableViewRow(
          cells: [
            TableViewCell(
              child: TextButton(
              onPressed: () {
                
              },
              child: const Text("5.000,00"),
            ),
            )
          ],          
        );
      }).toList(),
    );
  }

}