import 'package:firebase_write/models/user_preferences/user_preferences_connect.dart';
import 'package:firebase_write/models/user_preferences/user_preferences_register.dart';
import 'package:firebase_write/settings/manager_access/firebase/db_settings.dart';
import 'package:firebase_write/settings/manager_access/company/company_connect.dart';
import 'package:firebase_write/settings/manager_access/company/company_register.dart';
import 'package:firebase_write/settings/manager_access/user/user_register.dart';
import 'package:firebase_write/settings/manager_access/user_company/user_company_connect.dart';
import 'package:firebase_write/settings/manager_access/user_company/user_company_register.dart';

class ManagerAccess {

  static UserPreferencesRegister userPreferences = UserPreferencesRegister();

  Future<List<UserCompanyRegister?>?> getCompanys(UserRegister user) async {    
    List<UserCompanyRegister?>? connect = await UserCompanyConnect().getByIdUser(user.id!);
    return connect;
  }

  setDatabaseCompany(int idCompany) async {
    CompanyRegister? register = await CompanyConnect().getById(idCompany);
    await DBsettings.startCompanyDatabase(register!);
  }

/*
  getUserPreferences(int idUser) async {
    userPreferences = (await UserPreferencesConnect().getById(idUser))!;
  }*/



}