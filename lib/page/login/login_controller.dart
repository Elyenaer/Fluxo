
// ignore_for_file: unnecessary_null_comparison
import 'package:firebase_write/models/theme/theme_controller.dart';
import 'package:firebase_write/settings/manager_access/user/user_register.dart';
import 'package:firebase_write/settings/manager_access/user_company/user_company_register.dart';
import 'package:flutter/material.dart';
import '../../settings/manager_access/firebase/auth_settings.dart';

enum LoginState {loading,loaded}

class LoginController with ChangeNotifier{
  var state = LoginState.loaded;
  late String email, password;
  late List<UserCompanyRegister?> companys;
  late UserRegister userRegister;
  late ThemeController themeController;

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
    try{
      _setState(LoginState.loading);
      List response = await AuthSettings().signIn(email, password);
      _setState(LoginState.loaded);     

      companys = response[1];
      
      if(companys==null){
        return 'error';
      }
      if(companys.length>1){
        return 'multiple';
      }

      userRegister = response[2];

      //await ManagerAccess().setDatabaseCompany(companys[0]!.idCompany!);
      //await ManagerAccess().getUserPreferences(userRegister.id!);
      //themeController.current(userPreferences!.id_theme!);

      return 'one';
    }catch(e){
      debugPrint("LOGIN CONTROLLER AUTHENTICATION -> $e");
      return 'error';
    }    
  }

}