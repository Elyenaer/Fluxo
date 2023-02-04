
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
      ],
      child: MaterialApp(
        theme: themeMain,
        debugShowCheckedModeBanner: false,
        home: const ReportPage(),      
      ),      
    );  
  }
}
