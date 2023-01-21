
// ignore_for_file: camel_case_types

import 'package:intl/intl.dart';
import 'package:firebase_write/help/funcDate.dart';

class convert{

  static double currencyToDouble(String value){
    return double.parse(
      value.replaceAll('R\$ ','')
      .replaceAll('.','')
      .replaceAll(',','.'));
  }


  // ignore: non_constant_identifier_names
  static String doubleToCurrencyBR(double value){
    final formatter = NumberFormat("#,##0.00", "pt_BR");
    return "R\$ " + formatter.format(value);
  }

  //receive 01/10/2001 and return 20011001
  // ignore: non_constant_identifier_names
  static String DateBrToDatabase(String date){
    var d = date.split('/');
    return d[2] + d[1] + d[0];
  }

  //receive 01/10/2001 and return 2001/10/01
  // ignore: non_constant_identifier_names
  static String DateBrToDateUsa(String date){
    var d = date.split('/');
    return d[2] + '/' + d[1] +'/' + d[0];
  }

  // ignore: non_constant_identifier_names
  static String DatetimeToDateBr(DateTime d){
    return (funcDate.includeZeroDate(d.day) + '/' + funcDate.includeZeroDate(d.month) + '/' + d.year.toString());
  }

  // ignore: non_constant_identifier_names
  static String DatetimeToDatabase(DateTime d){
    return d.year.toString()+funcDate.includeZeroDate(d.month)+funcDate.includeZeroDate(d.day);
  }

  // convert String(01/01/2001) to Datetime
  // ignore: non_constant_identifier_names
  static DateTime StringToDatetime(String date){
    var d = date.split('/');
    return DateTime.parse(d[2] + '-' + d[1] +'-' + d[0]);
  }

   // ignore: non_constant_identifier_names
   static DateTime DatabaseToDatetime(String date){
    return DateTime.parse(
      date.substring(0,4) +'-'+ 
      date.substring(4,6) +'-'+ 
      date.substring(6,8));
  }

  // ignore: non_constant_identifier_names
  static String DatetimeMonthBr(int m){
    switch(m){
      case 1:
        return "JANEIRO";
      case 2:
        return "FEVEREIRO";
      case 3:
        return "MARÇO";
      case 4:
        return "ABRIL";
      case 5:
        return "MAIO";
      case 6:
        return "JUNHO";
      case 7:
        return "JULHO";
      case 8:
        return "AGOSTO";
      case 9:
        return "SETEMBRO"; 
      case 10:
        return "OUTUBRO";
      case 11:
        return "NOVEMBRO"; 
      case 12:
        return "DEZEMBRO";
    }
    return "";
  }

  // return date interval formated
  // ignore: non_constant_identifier_names
  static String DatePeriod(DateTime d,String period){
    try{
      if(period=='Diário'){
        return d.year.toString() + funcDate.includeZeroDate(d.month) + funcDate.includeZeroDate(d.day);
      }
      else if(period=='Semanal'){
        int start = d.day;
        int end = d.add(const Duration(days: 6)).day; 
        return (DatetimeMonthBr(d.month) + '\n' + funcDate.includeZeroDate(start)+'-'+ funcDate.includeZeroDate(end));            
      }else if(period=='Mensal'){
        return d.year.toString() + "\n" + DatetimeMonthBr(d.month);
      }else if(period=='Anual'){
        return d.year.toString();
      }
      return "";
    }catch(e){
      return '';
    }    
  }

  
}