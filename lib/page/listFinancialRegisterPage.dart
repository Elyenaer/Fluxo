
import 'package:firebase_write/page/financialEntryPage.dart';
import 'package:firebase_write/page/reportPage.dart';
import 'package:firebase_write/database.dart/register/financialEntryRegister.dart';
import 'package:flutter/material.dart';
import 'package:firebase_write/help/message.dart';
import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/settings/formats.dart';

// ignore: camel_case_types, must_be_immutable
class ListFinancialRegisterPage extends StatefulWidget{
    ListFinancialRegisterPage({
      Key? key,
      required this.idAccount,
      this.registers,
      required this.start,
      required this.end,
      required this.title
    }) : super(key: key);

    BuildContext? context;
    int idAccount;
    List<FinancialEntryRegister>? registers;
    DateTime start;
    DateTime end;
    reportPage? report;
    String title;

   @override
  _MyHomePageState createState() => _MyHomePageState();

}

  // ignore: non_constant_identifier_names
  class _MyHomePageState extends State<ListFinancialRegisterPage> {
  List<FinancialEntryRegister>? registers;
  late String title;
  bool isLoading = false;

  @override
  initState(){
    registers = widget.registers;
    title = widget.title;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ignore: unused_element
  void _isLoading(bool loading){
    setState(() {
      isLoading = loading;      
    });    
  }

  Future<void> _getRegisters() async {
    _isLoading(true);
    registers = await FinancialEntryRegister().getDataGapDateIdAccount(widget.idAccount,widget.start,widget.end);
    _isLoading(false);
  }

  void _deleteFinancialRegister(FinancialEntryRegister r) async{  
    bool confirm = await message.confirm(context,"CONFIRMA EXCLUSÃO?",
      "ID: " + r.id.toString() 
      + "\nDATA: " + convert.DatetimeToDateBr(r.date) + "\n" 
      + r.description.toUpperCase()
      + "\nVALOR: "
      + convert.doubleToCurrencyBR(r.value)
    ); 

    if(confirm){   
      _isLoading(true);       
      await r.delete();  
      registers?.remove(r);   
      _isLoading(false);         
    }    
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
        child: isLoading
          ? const Center(child: CircularProgressIndicator()):          
        Column(
        children: [
          _title(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: containerRegisters(),
            ),
          ),
        ],   
      ), 
    ); 
  }
  
  List<Widget> containerRegisters(){
    List<Widget> containerRegisters = <Widget>[];
    for(int i=0;i<registers!.length;i++){
      if(i>0){
        containerRegisters.add(const SizedBox(height: 10,));
      }
      containerRegisters.add(_showRegister(registers![i]));      
    }  
    return containerRegisters;
  }

  Widget _title(){
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
                heroTag: UniqueKey(),
                child: const Icon(Icons.arrow_back),
                onPressed: () {                  
                  Navigator.of(context).pop("update");
                },
              ),
            ),
            Expanded(
              child:Center(
                child: Text(
                  title
                )
              ), 
            ),   
            Transform.scale(
              alignment: Alignment.centerRight,
              scale: 0.5,
              child: FloatingActionButton(
                heroTag: UniqueKey(),
                child: const Icon(Icons.addchart_outlined),                                
                onPressed: () {
                  final updateCheck = Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => 
                      const FinancialEntryPage()),
                  );   
                  updateCheck.then((value) {
                    if(value=="update"){
                      setState(() {
                        _getRegisters();
                      });
                    }   
                  });    
                }
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
                    heroTag: UniqueKey(),
                    child: const Icon(Icons.edit),                                
                    onPressed: () {
                      final updateCheck = Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => 
                            FinancialEntryPage(
                              register: r,)),
                        ); 
                        updateCheck.then((value) {
                          if(value=="update"){
                            setState(() {
                              _getRegisters();
                             });
                          }
                        });
                    },
                  ),
                  const SizedBox(width: 10,),
                  FloatingActionButton(
                    heroTag: UniqueKey(),
                    child: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteFinancialRegister(r);                                   
                    },
                  ),
                ],
              ),
            ),
          ],
        )  
      ),    
    );
  }

}
