import 'package:firebase_write/models/theme/theme_controller.dart';
import 'package:firebase_write/page/report/report_controller.dart';
import 'package:firebase_write/page/report/report_page.dart';
import 'package:firebase_write/page/account_manager/account_manager_controller.dart';
import 'package:firebase_write/page/financial_register/financial_entry_controller.dart';
import 'package:firebase_write/page/list_financial_register/list_financial_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Elyfluxo extends StatelessWidget {
  const Elyfluxo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {        
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ReportController(),),
        ChangeNotifierProvider(create: (ctx) => AccountManagerController(),),
        ChangeNotifierProvider(create: (ctx) => ListFinancialRegisterController(),),
        ChangeNotifierProvider(create: (ctx) => FinancialEntryController(),),
        ChangeNotifierProvider(create: (ctx) => ThemeController())
      ],      
      child: MaterialApp(
        theme: ThemeController.theme,
        debugShowCheckedModeBanner: false,
        home: const ReportPage(),      
      ),      
    );  
  }
}
