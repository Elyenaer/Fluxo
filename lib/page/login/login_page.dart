import 'package:firebase_write/help/message.dart';
import 'package:firebase_write/page/login/auth_service.dart';
import 'package:firebase_write/page/report/report_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_write/help/valid.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email, password;

  final formKey = GlobalKey<FormState>();

  checkFields() {
    final form = formKey.currentState;
    if (form!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 250.0,
          width: 300.0,
          child: Column(
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _emailTextField(),
                    _passwordTextField(),
                    _signButton()
                  ],
                )
              )
            ],
          )
        )
      )
    );
  }

  _emailTextField(){
    return Padding(
      padding: const EdgeInsets.only(
        left: 25.0,
        right: 25.0,
        top: 20.0,
        bottom: 5.0
      ),
      child: SizedBox(
        height: 50.0,
        child: TextFormField(
          decoration:const InputDecoration(
            hintText: 'Email'
          ),
          validator: (value) => value!.isEmpty
              ? 'Email is required'
              : valid.validateEmail(value.trim()),
          onChanged: (value) {
            email = value;
          },
        ),
      )
    );
  }

  _passwordTextField(){
    return Padding(
      padding: const EdgeInsets.only(
          left: 25.0,
          right: 25.0,
          top: 20.0,
          bottom: 5.0
        ),
      child: SizedBox(
        height: 50.0,
        child: TextFormField(
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Password'),
          validator: (value) => value!.isEmpty
              ? 'Password is required'
              : null,
          onChanged: (value) {
            password = value;
          },
        ),
      )
    );
  }

  _signButton(){
    return InkWell(
      onTap: () async {
        if (checkFields()) {
          var response = await AuthService().signIn(email, password);
          
          if(response=='success'){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => 
                  const ReportPage()),
              );   
          }else{
            message.simple(context,"ERRO",response);
          }

        }
      },
      child: Container(
        height: 40.0,
        width: 100.0,
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
        ),
        child: const Center(
          child: Text('Sign in')
        )
      )
    );
  }

}