
import 'package:firebase_write/page/account_manager/account_manager_controller.dart';
import 'package:firebase_write/page/financial_register/financial_entry_controller.dart';
import 'package:firebase_write/page/list_financial_register/list_financial_register_controller.dart';
import 'package:firebase_write/page/report/report_controller.dart';
import 'package:firebase_write/page/report/report_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../settings/theme.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeData themeMain = await theme().current();
  await Firebase.initializeApp();
  runApp(MyApp(themeMain: themeMain));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
    required this.themeMain,
  }) : super(key: key);

  ThemeData themeMain;
  
  @override
  Widget build(BuildContext context) {    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ReportController(),),
        ChangeNotifierProvider(create: (ctx) => AccountManagerController(),),
        ChangeNotifierProvider(create: (ctx) => ListFinancialRegisterController(),),
        ChangeNotifierProvider(create: (ctx) => FinancialEntryController(),),
      ],
      child: MaterialApp(
        theme: themeMain,
        debugShowCheckedModeBanner: false,
        home: const ReportPage(),      
      ),      
    );  
  }
}
