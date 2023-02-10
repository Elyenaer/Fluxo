
import 'package:firebase_write/models/account_group/accountGroupController.dart';
import 'package:firebase_write/page/accountManager/account_manager_controller.dart';
import 'package:firebase_write/page/accountManager/account_manager_page.dart';
import 'package:firebase_write/page/financialEntryPage.dart';
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
        ChangeNotifierProvider(
          create: (ctx) => ReportController(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AccountManagerController(),
        ),
      ],
      child: MaterialApp(
        theme: themeMain,
        debugShowCheckedModeBanner: false,
        home: const AccountManagerPage(),      
      ),      
    );  
  }
}
