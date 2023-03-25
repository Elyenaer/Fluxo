
import 'package:firebase_write/models/user/user/user_connect.dart';
import 'package:firebase_write/models/user/user/user_register.dart';

class CreateUser {
  UserRegister user;

  CreateUser(this.user);

  create() async {
    int id = await UserConnect().setData(user);
    return await UserConnect().getDataById(id);
  }
  
}