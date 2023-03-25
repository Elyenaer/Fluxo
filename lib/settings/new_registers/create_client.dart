
import 'package:firebase_write/models/account/account_connect.dart';
import 'package:firebase_write/models/account/account_register.dart';
import 'package:firebase_write/models/account_group/account_group_connect.dart';
import 'package:firebase_write/models/account_group/account_group_register.dart';
import 'package:firebase_write/models/client/client_connect.dart';
import 'package:firebase_write/models/client/client_register.dart';
import 'package:firebase_write/models/user/user/user_connect.dart';
import 'package:firebase_write/models/user/user/user_register.dart';
import 'package:firebase_write/models/user/user_access/user_access_connect.dart';
import 'package:firebase_write/models/user/user_access/user_access_register.dart';
import 'package:firebase_write/models/user/user_preferences/user_preferences_connect.dart';
import 'package:firebase_write/models/user/user_preferences/user_preferences_register.dart';
import 'package:firebase_write/settings/manager_access/current_access/current_access.dart';
import 'package:firebase_write/settings/new_registers/create_user.dart';

class CreateClient {
  ClientRegister client;  
  UserRegister user;
  late UserPreferencesRegister userPreferences;

  CreateClient(this.client,this.user);

  create() async {
    await _createClient();
    await _createUser();
    await _createUserPreferences();
    await _createUserAccess();    
    await _createAccounts();
  }

  _createClient() async {
    int id = await ClientConnect().setData(client);
    client = (await ClientConnect().getById(id))!;
    CurrentAccess.client = client;
  }

  _createUser() async {
    UserRegister? temp = await UserConnect().getUserByEmail(user.email!);
    if(temp==null){
      user = await CreateUser(user).create();
    }else{
      user = temp;
    }
    CurrentAccess.user = user;
  }

  _createUserPreferences() async {
    userPreferences = UserPreferencesRegister.getDefault();
    int id = await UserPreferencesConnect().setData(userPreferences);
    userPreferences = (await UserPreferencesConnect().getById(id))!;
  }

  _createUserAccess() async {
    UserAccessRegister userAccess = UserAccessRegister();
    userAccess.clientId = client.id;
    userAccess.userId = user.id;
    userAccess.userPreferencesId = userPreferences.id_user_preferences;
    await UserAccessConnect().setData(userAccess);
  }

  _createAccounts() async {
    AccountGroupRegister group = AccountGroupRegister();
    group.description = "Despesas";
    group.idClient = client.id;
    group.sequence = 1;
    var id = await AccountGroupConnect().setData(group);

    AccountRegister account = AccountRegister();
    account.description = "Aluguel";
    account.credit = true;
    account.groupSequence = 1;
    account.idGroup = id;
    account.idClient = client.id;
    await AccountConnect().setData(account);
  }

}