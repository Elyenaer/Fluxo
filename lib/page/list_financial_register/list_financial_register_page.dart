
import 'package:firebase_write/custom/widgets/customFloatingButton.dart';
import 'package:firebase_write/models/account/account_register.dart';
import 'package:firebase_write/models/financial_entry/financial_entry_register.dart';
import 'package:firebase_write/page/financial_register/financial_entry_page.dart';
import 'package:firebase_write/page/list_financial_register/list_financial_register_controller.dart';
import 'package:firebase_write/page/list_financial_register/show_financial_register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types, must_be_immutable
class ListFinancialRegisterPage extends StatefulWidget{
    ListFinancialRegisterPage({
      Key? key,
      required this.account,
      this.registers,
      required this.start,
      required this.end,
      required this.title
    }) : super(key: key);

    AccountRegister account;
    List<FinancialEntryRegister>? registers;
    DateTime start;
    DateTime end;
    String title;

   @override
  _MyHomePageState createState() => _MyHomePageState();

}

  // ignore: non_constant_identifier_names
class _MyHomePageState extends State<ListFinancialRegisterPage> {
  late ListFinancialRegisterController controller;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller = Provider.of(context);
    controller.setData(widget.account.id!,widget.start,widget.end);
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: controller.state == ListFinancialRegisterState.loading
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
    for(int i=0;i<widget.registers!.length;i++){
      if(i>0){
        containerRegisters.add(const SizedBox(height: 10,));
      }
      containerRegisters.add(
        ShowFinancialRegister(
          register: widget.registers![i],
          controller: controller,
        )
      );      
    }  
    return containerRegisters;
  }

  Widget _title(){
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
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
              child: CustomFloatingButton(
                icon: Icons.arrow_back,
                onPressed: () {                  
                  Navigator.of(context).pop("update");
                },
              ),
            ),
            Expanded(
              child:Center(
                child: Text(                  
                  widget.account.description!.toUpperCase() + "\n" + widget.title.replaceAll('\n'," "),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                    fontWeight: FontWeight.bold                    
                  ),
                )
              ), 
            ),   
            Transform.scale(
              alignment: Alignment.centerRight,
              scale: 0.5,
              child: CustomFloatingButton(    
                icon: Icons.addchart_outlined,                                
                onPressed: () {
                  final updateCheck = Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FinancialEntryPage()
                    ),
                  );   
                  updateCheck.then((value) {
                    if(value=="update"){
                      controller.update();
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
  
}
