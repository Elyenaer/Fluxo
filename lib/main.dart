
import 'package:firebase_write/models/theme/theme_controller.dart';
import 'package:firebase_write/settings/adm/new_project_controller.dart';
import 'package:firebase_write/settings/adm/new_project_page.dart';
import 'package:firebase_write/settings/manager_access/firebase/db_settings.dart';
import 'package:firebase_write/page/login/login_controller.dart';
//import 'package:firebase_write/page/login/login_page.dart';
import 'package:firebase_write/page/account_manager/account_manager_controller.dart';
import 'package:firebase_write/page/financial_register/financial_entry_controller.dart';
import 'package:firebase_write/page/list_financial_register/list_financial_register_controller.dart';
import 'package:firebase_write/page/report/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  await DBsettings.startManagerUser();
  runApp(const MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  const MyApp({
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
        ChangeNotifierProvider(create: (ctx) => LoginController()),
        ChangeNotifierProvider(create: (ctx) => ThemeController()),
        ChangeNotifierProvider(create: (ctx) => NewProjectController())
      ],
      
      child: MaterialApp(
        theme: ThemeController.theme,
        debugShowCheckedModeBanner: false,
        home: const NewProjectPage(),      
      ),      
    );  
  }
}
