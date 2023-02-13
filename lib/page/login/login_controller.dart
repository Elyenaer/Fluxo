
import 'package:flutter/material.dart';

import 'auth_service.dart';

enum LoginState {loading,loaded}

class LoginController with ChangeNotifier{
  var state = LoginState.loaded;
  late String email, password;

  final formKey = GlobalKey<FormState>();

  _setState(LoginState s){
    state = s;
    notifyListeners();
  }

  checkFields() {
    _setState(LoginState.loading);
    final form = formKey.currentState;
    if (form!.validate()) {
      _setState(LoginState.loaded);
      return true;
    } else {
      _setState(LoginState.loaded);
      return false;
    }
  }

  authentication() async {
    _setState(LoginState.loading);
    String response = await AuthService().signIn(email, password);
    _setState(LoginState.loaded);
    return response;
  }
  
}