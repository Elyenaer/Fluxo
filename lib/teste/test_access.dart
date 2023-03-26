
import 'package:firebase_write/main_elyfluxo.dart';
import 'package:firebase_write/models/client/client_register.dart';
import 'package:firebase_write/models/user/user/user_register.dart';
import 'package:firebase_write/settings/manager_access/current_access/current_access.dart';
import 'package:flutter/material.dart';

class TestAccess {

  set() async {
    CurrentAccess.client = ClientRegister(
      17, 
      "Elyenaer Farias dos Santos",
      "F"
    );
    CurrentAccess.user = UserRegister(
      10, 
      "elyenaer",
      "elyenaer@gmail.com"
    );
    //CurrentAccess.userPreferences = (await UserPreferencesConnect().getById(10))!;
    runApp(const Elyfluxo());
  }

}