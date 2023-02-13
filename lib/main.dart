
import 'package:firebase_write/firebase/firebase_config.dart';
import 'package:firebase_write/page/login/auth_service.dart';
import 'package:firebase_write/page/login/login_page.dart';
import 'package:firebase_write/page/account_manager/account_manager_controller.dart';
import 'package:firebase_write/page/financial_register/financial_entry_controller.dart';
import 'package:firebase_write/page/list_financial_register/list_financial_register_controller.dart';
import 'package:firebase_write/page/report/report_controller.dart';
import 'package:firebase_write/page/report/report_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  await FirebaseConfig.start();
  ThemeData themeMain = await theme().current();
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
        home: const LoginPage(),      
      ),      
    );  
  }
}
