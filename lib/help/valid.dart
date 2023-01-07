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

}