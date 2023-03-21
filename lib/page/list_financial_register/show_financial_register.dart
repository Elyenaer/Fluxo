

import 'package:firebase_write/custom/widgets/customFloatingButton.dart';
import 'package:firebase_write/models/financial_entry/financial_entry_register.dart';
import 'package:firebase_write/page/financial_register/financial_entry_page.dart';
import 'package:firebase_write/page/list_financial_register/list_financial_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/settings/formats.dart';

// ignore: must_be_immutable
class ShowFinancialRegister extends StatelessWidget{
  ShowFinancialRegister({
    Key? key,
    required this.register,
    required this.controller
    }) 
    : super(key: key);

  FinancialEntryRegister register;
  ListFinancialRegisterController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      padding: const EdgeInsets.fromLTRB(10,10,10,0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(width: 2, color: Theme.of(context).primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ), 
      child: Center(
        child: Column(
          children: [
            Row(
              verticalDirection: VerticalDirection.up,
              children: [
                formats.standard(convert.DatetimeToDateBr(register.date!),Theme.of(context).colorScheme.onSurface),
                const SizedBox(width: 20,),
                Expanded(
                  child: formats.standard(register.description!,Theme.of(context).colorScheme.onSurface),              
                ), 
                const SizedBox(width: 20,),
                formats.standard(convert.doubleToCurrencyBR(register.value!),Theme.of(context).colorScheme.onSurface)
              ],
            ),   
            Transform.scale(
              alignment: Alignment.centerRight,
              scale: 0.5,
              child:Row(
                verticalDirection: VerticalDirection.up,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomFloatingButton(
                    icon: Icons.edit,                                
                    onPressed: () {
                      final updateCheck = Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => 
                            FinancialEntryPage(
                              register: register,)),
                        ); 
                        updateCheck.then((value) {
                          if(value=="update"){
                            controller.update();
                          }
                        });
                    },
                  ),
                  const SizedBox(width: 10,),
                  CustomFloatingButton(
                    icon: Icons.delete_forever_rounded,
                    onPressed: () {
                      controller.deleteFinancialRegister(context, register);                                 
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
