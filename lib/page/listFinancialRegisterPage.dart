
import 'package:firebase_write/page/financialEntryPage.dart';
import 'package:firebase_write/register/financialEntryRegister.dart';
import 'package:flutter/material.dart';
import 'package:firebase_write/help/message.dart';
import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/settings/formats.dart';

// ignore: camel_case_types, must_be_immutable
class ListFinancialRegisterPage extends StatefulWidget{
    ListFinancialRegisterPage({
      Key? key,
      this.registers,
      required this.title
    }) : super(key: key);

    BuildContext? context;
    List<FinancialEntryRegister>? registers;
    Widget title;

   @override
  _MyHomePageState createState() => _MyHomePageState();

}

  // ignore: non_constant_identifier_names
  class _MyHomePageState extends State<ListFinancialRegisterPage> {
  List<FinancialEntryRegister>? registers;
  late Widget title;
  bool isLoading = false;

  @override
  initState(){
    registers = widget.registers;
    title = widget.title;
    super.initState();
  }

  @override
  void dispose() {
    print(" 5 ---------> $context");
    Navigator.pop(context,"Devoldo");
    super.dispose();
  }


  // ignore: unused_element
  void _isLoading(bool loading){
    setState(() {
      isLoading = loading;      
    });    
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
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => 
                            FinancialEntryPage(register: r,)),
                        ); 
                      });                                   
                    },
                  ),
                  const SizedBox(width: 10,),
                  FloatingActionButton(
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
