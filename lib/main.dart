
import 'package:firebase_write/page/financialEntryPage.dart';
import 'package:firebase_write/page/reportPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
    return MaterialApp(
      theme: themeMain,
      debugShowCheckedModeBanner: false,
      home: const FinancialEntryPage(),      
    );
  }
}
