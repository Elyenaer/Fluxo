
import 'package:firebase_write/help/convert.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class funcDate{

  //get weekday, if week start in saturday and end friday, 
  //if receive thrhusday return next friday if next=true 
  //or previous saturday if next=false
  static DateTime getWeekday(DateTime d,bool next,int dayWeekStart){
    try{
      if(d.weekday==dayWeekStart){
        if(next){
          return d.add(const Duration(days: 6));
        }else{
          return d;
        }
      }else if(d.weekday>dayWeekStart){
        if(next){
          return d.add(Duration(days: dayWeekStart-d.weekday+6));
        }else{
          return d.add(Duration(days: dayWeekStart-d.weekday));
        }
      }else{
        if(next){
          return d.add(Duration(days: (dayWeekStart-d.weekday-1)));
        }else{
          return d.add(Duration(days: -1*(7-(dayWeekStart-d.weekday))));
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
      return DateTime(d.year+1,1,d.day);
    }else{
      return DateTime(d.year,d.month+1,d.day);
    }
  }

  static DateTime addYear(DateTime d){
    return DateTime(d.year+1,d.month,d.day);
  }






}