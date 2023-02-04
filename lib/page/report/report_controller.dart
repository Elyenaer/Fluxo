
import 'package:firebase_write/models/account/accountRegister.dart';
import 'package:firebase_write/models/account_group/accountGroupController.dart';
import 'package:firebase_write/page/report/group_register.dart';
import 'package:firebase_write/page/report/row_register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/help/funcDate.dart';
import 'package:firebase_write/settings/theme.dart';
import 'package:intl/intl.dart';
import '../../database.dart/connection/financialEntryConnect.dart';
import '../../database.dart/register/financialEntryRegister.dart';
import '../../models/account/accountConnect.dart';

class ReportController with ChangeNotifier {
  late List<GroupRegister> groups = <GroupRegister>[];
  late final List<String> columnTitle = <String>[];
  final TextEditingController tecDateStart = TextEditingController(text: '');
  final TextEditingController tecDateEnd = TextEditingController(text: '');
  late DateTime start,end;

  List<String> periodList = <String>['Diário', 'Semanal', 'Mensal', 'Anual'];
  String periodValue = 'Diário';

  static const double columnWidth = 100;
  static const double rowHeight = 50;
  static const double rowHeightGap = 20;      
  late double scalePanel = 1.0;

  ReportController(){
    tecDateStart.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    tecDateEnd.text = DateFormat('dd/MM/yyyy').format(DateTime.now().add(const Duration(days: 2)));      
    update();
  }

  update(){
    _getRegister();
  }
  
  _getColumnTitle(){    
    columnTitle.clear();
    DateTime d;
    if(periodValue=="Diário"){
      start = convert.StringToDatetime(tecDateStart.text);
      end = convert.StringToDatetime(tecDateEnd.text);
      d = start;
      int periodLenght = end.difference(d).inDays;
      for(int i=0;i<periodLenght+1;i++){
        columnTitle.add(d.year.toString() +
         "\n" + convert.DatetimeMonthBr(d.month,true) + 
         "\n" + d.day.toString());
        d = d.add(const Duration(days: 1));        
      }
    }
    else if(periodValue=="Semanal"){
      start = funcDate.getWeekday(
        convert.StringToDatetime(tecDateStart.text),false,6);
      end = funcDate.getWeekday(
        convert.StringToDatetime(tecDateEnd.text),true,6);    
      d = start;
      while(!d.isAfter(end)){
        columnTitle.add(convert.DatePeriod(d, periodValue));    
        d = d.add(const Duration(days: 7));              
      }
    }else if(periodValue=="Mensal"){
      start = funcDate.getMonth(
        convert.StringToDatetime(tecDateStart.text),true);
      end = funcDate.getMonth(
        convert.StringToDatetime(tecDateEnd.text),false);
      d = start;
      while(!d.isAfter(end)){
        columnTitle.add(convert.DatePeriod(d, periodValue));    
        d = funcDate.addMonth(d);  
      }
    }else{
      start = funcDate.getYear(
        convert.StringToDatetime(tecDateStart.text),true);
      end = funcDate.getYear(
        convert.StringToDatetime(tecDateEnd.text),false);
      d = start;
      while(!d.isAfter(end)){
        columnTitle.add(convert.DatePeriod(d, periodValue));    
        d = funcDate.addYear(d);  
      }
    }
    return columnTitle;
  }
    
  _getGroup() async {
    groups.clear();
    groups = await AccountGroupController().getGroups();
  }

  _getAccount() async{
     _getGroup();
    List<AccountRegister>? account = await AccountConnect().getData();   
    for(int i=0;i<account!.length;i++){
      RowRegister temp = RowRegister(account[i],columnTitle.length);
      for(int j=0;j<groups.length;j++){
        if(groups[j].group.id==account[i].idGroup){
          groups[i].add(temp);
        }        
      }
    }
  }

  _getRegister() async {
    try{
      _getColumnTitle();     
      _getAccount();
      List<FinancialEntryRegister>? reg = await FinancialEntryConnect().getDataGapDate(start,end);
      int positionArray = 0;
      DateTime d = start;
      DateTime d2; //interval from d to d2

      while(!d.isAfter(end)){
        if(periodValue=="Diário"){
          d2 = d;
        }else if(periodValue=="Semanal"){
          d2 = d.add(const Duration(days: 6));
        }else if(periodValue=="Mensal"){
          d2 = funcDate.getMonth(d,false);
        }else{
          d2 = funcDate.getYear(d,false);
        }

        for(int i=0;i<reg!.length;i++){
          if(reg[i].date.isAfter(d2)){
            break;
          }else if(reg[i].date.isBefore(d)){
            continue;
          }
          for(int j=0;j<groups.length;j++){
            for(int x=0;x<groups[j].rows.length;x++){
              if(reg[i].accountId==groups[j].rows[x].account.id){
                groups[j].rows[x].include(reg[i],positionArray);
              }
            }
          }
        }

        if(periodValue=="Diário"){
          d = d.add(const Duration(days: 1));
        }else if(periodValue=="Semanal"){
          d = d.add(const Duration(days: 7));
        }else if(periodValue=="Mensal"){
          d = funcDate.addMonth(d);
        }else{
          d = DateTime(d.year+1,1,1);
        }    

        positionArray++;
      }
      
      notifyListeners();
    }catch(e){
      print('REPORT CONTROLLER ERRO _GETREGISTER -> $e');
      return '';
    }
  }

  getColumnWidht(){
    return columnWidth*scalePanel;
  }

  getLeftHandSideColumnWidht(){
    return (columnWidth+20)*scalePanel;
  }

  getRightHandSideColumnWidht(){
    return columnWidth*(columnTitle.length)*scalePanel;
  }

  getRowHeight(){
    return rowHeight*scalePanel;
  }

  getRowHeightGap(){
    return rowHeightGap*scalePanel;
  }

  getBackgroundRowTitle(int index){
    if(registers[index].account.credit!){
      if(index % 2 == 0){
        return theme.backgroundTitleDebt1;
      }else{
        return theme.backgroundTitleDebt2;
      }
    }else{
      if(index == 0){
        return theme.backgroundTitleCredit1;
      }else{
        return theme.backgroundTitleCredit2;
      }
    }
  }

  getBackGroundRowCell(int index){
    if(!registers[index].account.credit!){
      if(index % 2 == 0){
        return theme.backgroundEntryCredit1;
      // ignore: dead_code
      }else{
        return theme.backgroundEntryCredit2;
      }
    }else{
      if(index % 2 == 0){
        return theme.backgroundEntryDebt1;
      // ignore: dead_code
      }else{
        return theme.backgroundEntryDebt2;
      }
    }
  }

  getForeground(bool credit){
    if(!credit){
      return theme.foregroundEntryCredit;
    }else{
      return theme.foregroundEntryDebt;
    }
  }

  getRowsQuantity(){
    int total = 0;
    for(int i=0;i<groups.length;i++){
      total += groups[i].rows.length;
    }
    return total;
  }

  setScale(double newScale){
    scalePanel = newScale;
    notifyListeners();
  }

  setPeriod(String value){
    periodValue = value;
    update();
  }

}