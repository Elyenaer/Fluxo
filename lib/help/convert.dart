
// ignore_for_file: camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

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
    return (includeZeroDate(d.day) + '/' + includeZeroDate(d.month) + '/' + d.year.toString());
  }

  // ignore: non_constant_identifier_names
  static String DatetimeToDatabase(DateTime d){
    return d.year.toString()+includeZeroDate(d.month)+includeZeroDate(d.day);
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
        return d.year.toString() + includeZeroDate(d.month) + includeZeroDate(d.day);
      }
      else if(period=='Semanal'){
        int start = d.day;
        int end = d.add(const Duration(days: 7)).day; 
        return (DatetimeMonthBr(d.month) + '\n' + includeZeroDate(start)+'-'+includeZeroDate(end));            
      }else if(period=='Mensal'){
        return (((d.year) as String) + "/" + DatetimeMonthBr(d.month));
      }else if(period=='Anual'){
        return d.year as String;
      }
      return "";
    }catch(e){
      return '';
    }    
  }

  //get weekday, if week start in saturday and end friday, 
  //if receive thrhusday return next friday if next=true 
  //or previous saturday if next=false
  static DateTime getWeekday(DateTime d,bool next,int dayTarget){
    try{
      if(d.weekday==dayTarget){
          return d;
      }else if(d.weekday>dayTarget){
        if(next){
          return d.add(Duration(days: (dayTarget-(d.weekday+7))));
        }else{
          return d.add(Duration(days: dayTarget-d.weekday));
        }
      }else{
        if(next){
          return d.add(Duration(days: (dayTarget-d.weekday)));
        }else{
          return d.add(Duration(days: -1*(7-(dayTarget-d.weekday))));
        }
      }
    }catch(e){
      debugPrintStack(label: 'Erro getWeekDay -> $e');
      return d;
    }
  }

  //get firt or last day of month,
  //if start = true return fisrt or return last if start = false
  static DateTime getMonth(DateTime d,bool start){
    if(start){
      return DateTime(d.year,d.month,1);
    }else{
      if(d.month==12){
        return DateTime(d.year+1,1,0);
      }else{
        return DateTime(d.year,d.month+1,0);
      }
    }
  }

  //get firt or last day of year
  //if start = true return fisrt or return last if start = false
  static DateTime getYear(DateTime d,bool start){
    if(start){
      return DateTime(d.year,1,1);
    }else{
      return DateTime(d.year+1,1,0);
    }
  }

  static String includeZeroDate(int dm){
    String help = '';
    if(dm<10){
      help = '0';
    }
    return help+dm.toString();
  }

  static DateTime addMonth(DateTime d){
    if(d.month==12){
      return DateTime(d.year+1,1,0);
    }else{
      return DateTime(d.year,d.month+1,0);
    }
  }
}