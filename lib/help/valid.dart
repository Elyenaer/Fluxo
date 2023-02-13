import 'package:intl/intl.dart';

// ignore: camel_case_types
class valid{

  static String? checkDate(String d){
    try{

      //check if user has writen digit enough to valid
      if (d.length<10){ 
        return null;
      }

      //try to valid date format
      DateFormat("dd/MM/yyyy").parseStrict(d);

      return null;
    }catch(e){
      return 'Data Inválida';
    }    
  }

  static String? validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)){
      return 'Enter Valid Email';
    }
    else{
      return null;
    }
  }



}