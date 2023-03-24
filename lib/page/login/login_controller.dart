
// ignore_for_file: unnecessary_null_comparison
import 'package:firebase_write/main_elyfluxo.dart';
import 'package:firebase_write/models/client/client_connect.dart';
import 'package:firebase_write/models/client/client_register.dart';
import 'package:firebase_write/models/theme/theme_controller.dart';
import 'package:firebase_write/models/user/user_access/user_access_connect.dart';
import 'package:firebase_write/models/user/user_access/user_access_register.dart';
import 'package:firebase_write/settings/manager_access/current_access/current_access.dart';
import 'package:flutter/material.dart';
import '../../settings/manager_access/firebase/auth_settings.dart';

enum LoginState {loading,loaded,startAccess}

class LoginController with ChangeNotifier{
  var state = LoginState.loaded;
  late String email, password;
  late List<UserAccessRegister?> access;
  late List<ClientRegister?> clients;

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
    String response = 'error';
    try{
      _setState(LoginState.loading);
      response = await AuthSettings().signIn(email, password);
       
      await _getAccess();
      
      if(access==null){
        _setState(LoginState.loaded);  
        return response;
      }

      if(access.length>1){
        _setState(LoginState.loaded);  
        return 'multiple';
      }
      _startAccess(access[0]!);
      return 'one';
    }catch(e){
      debugPrint("LOGIN CONTROLLER AUTHENTICATION -> $e");
      return e;
    }    
  }

  _getAccess() async {
    access = (await UserAccessConnect().getDataByUser(CurrentAccess.user.id!))!;

    clients = <ClientRegister?>[];
    for(var a in access){
      clients.add(await ClientConnect().getById(a!.id!));
    }
  }

  _startAccess(UserAccessRegister userAccess) async {
    state = LoginState.loading;
    await CurrentAccess().userPreferencesStart(userAccess.userPreferencesId!);
    await CurrentAccess().clientStart(userAccess.clientId!);
    await ThemeController().get(CurrentAccess.userPreferences.id_theme!);   
    runApp(const Elyfluxo()); 
    state = LoginState.startAccess;
  }

  startAccesByClient(idClient){
    try{
      UserAccessRegister? uar = access.firstWhere((element) => element?.clientId == idClient);
      _startAccess(uar!);   
    }catch(e){
      debugPrint("LOGIN CONTROLLER ERROR STARTACCESBYCLIENT -> $e");
    }     
  }

}