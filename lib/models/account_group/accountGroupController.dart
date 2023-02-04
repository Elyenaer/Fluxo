
import 'package:firebase_write/models/account_group/accountGroupConnect.dart';

class AccountGroupController {

getGroups() async {
  return await AccountGroupConnect().getData();
}







}