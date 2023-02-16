
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_write/settings/manager_access/manager_access.dart';
import 'package:firebase_write/settings/manager_access/user/user_connect.dart';
import 'package:firebase_write/settings/manager_access/user/user_register.dart';
import 'package:firebase_write/settings/manager_access/user_company/user_company_register.dart';

class AuthSettings {
  //Handle Authentication
  /*
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instanceFor(app: DBsettings.managerAccess).authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const ReportPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }*/

  //Sign Out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //Sign in
  Future<List> signIn(email, password) async {
    String response = '';
    List<UserCompanyRegister?>? company;
    UserRegister? user;
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      ).then((userCredential) async {
          user = await _getUser(userCredential);
          company = await _checkUserAccess(user!);
        }
      ).catchError(
        (e) {
          response = e;
        }
      );
      return [response,company,user];
    }catch(e){
      response = e.toString();
      return [response,company,user];
    }
  }

  Future<UserRegister?> _getUser(UserCredential userCredential) async {
    return await UserConnect().getByUid(userCredential.user!.uid);
  }

  Future<List<UserCompanyRegister?>?> _checkUserAccess(UserRegister user) async {
    try{
      return await ManagerAccess().getCompanys(user);
    }catch(e){
      return null;
    }
  }
    
}