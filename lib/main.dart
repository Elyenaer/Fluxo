
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_write/page/login/login_controller.dart';
import 'package:firebase_write/page/login/login_page.dart';
import 'package:firebase_write/settings/manager_access/firebase/auth_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

late final FirebaseAuth auth;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await AuthSettings.start();
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
        ChangeNotifierProvider(create: (ctx) => LoginController())
      ],      
      child: MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: const LoginPage(),      
      ),      
    );  
  }
}
