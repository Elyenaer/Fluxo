// ignore_for_file: must_be_immutable

import 'package:firebase_write/help/message.dart';
import 'package:firebase_write/page/login/login_controller.dart';
import 'package:firebase_write/page/login/login_select_client_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_write/help/valid.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) 
  : super(key: key);


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginController controller;

  @override
  Widget build(BuildContext context) {
    controller = Provider.of(context);

    if(controller.state == LoginState.startAccess){
      dispose();
    }

    return Scaffold(
      body: controller.state == LoginState.loading
      ? const Center(child: CircularProgressIndicator())
      : Center(
        child: SizedBox(
          height: 250.0,
          width: 300.0,
          child: Column(
            children: <Widget>[
              Form(
                key: controller.formKey,
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
            controller.email = value;
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
            controller.password = value;
          },
        ),
      )
    );
  }

  _signButton(){
    return InkWell(
      onTap: () async {
        if (controller.checkFields()) {
          var response = await controller.authentication();   
          if(response=='one'){  
                           
          }else if((response=='multiple')){
            final int? result = await LoginSelectClientDialog(context, controller.clients);  
            if(result!>0){
              controller.startAccesByClient(result);
            }            
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