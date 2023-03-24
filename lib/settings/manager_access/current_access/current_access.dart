

import 'package:firebase_write/models/client/client_connect.dart';
import 'package:firebase_write/models/client/client_register.dart';
import 'package:firebase_write/models/user/user/user_connect.dart';
import 'package:firebase_write/models/user/user/user_register.dart';
import 'package:firebase_write/models/user/user_credential/user_credential_register.dart';
import 'package:firebase_write/models/user/user_preferences/user_preferences_connect.dart';
import 'package:firebase_write/models/user/user_preferences/user_preferences_register.dart';

class CurrentAccess {
  static UserRegister user = UserRegister.getDefault();
  static ClientRegister client = ClientRegister.getDefault();
  static UserPreferencesRegister userPreferences = UserPreferencesRegister.getDefault();

  userStart(UserCredentialRegister userCredential) async {
    user = (await UserConnect().getUserByCredential(userCredential))!;
  }

  clientStart(int clientId) async {
    client = (await ClientConnect().getById(clientId))!;
  }

  userPreferencesStart(int userPreferencesId) async {
    userPreferences = (await UserPreferencesConnect().getById(userPreferencesId))!;
  }

}