
import 'package:firebase_write/models/account/accountRegister.dart';
import 'package:firebase_write/models/account_group/accountGroupController.dart';
import 'package:firebase_write/models/account_group/accountGroupRegister.dart';
import 'package:firebase_write/page/report/balance_register.dart';
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

enum ReportState {loading,loaded}

class ReportController with ChangeNotifier {
  var state = ReportState.loading;

  late List<GroupRegister> groups = [];
  late BalanceRegister periodBalance,accumulatedBalance;
  late final List<String> columnTitle = [];
  final TextEditingController tecDateStart = TextEditingController(text: '');
  final TextEditingController tecDateEnd = TextEditingController(text: '');
  late DateTime start,end;

  List<String> periodList = <String>['Diário', 'Semanal', 'Mensal', 'Anual'];
  String periodValue = 'Diário';  

  static const double columnWidth = 100;
  static const double rowHeight = 40;
  static const double rowHeightGap = 20;      
  late double scalePanel = 1.0;

  ReportController(){
    tecDateStart.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    tecDateEnd.text = DateFormat('dd/MM/yyyy').format(DateTime.now().add(const Duration(days: 2)));      
    update();
  }

  update() async {  
    await _getColumnTitle();  
    await _getGroup();  
    await _getAccount();
    await _getRegister();
    await _getBalances();
    state = ReportState.loaded;
    notifyListeners();
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
    List<AccountGroupRegister> g = await AccountGroupController().getGroups();
    for(int i=0;i<g.length;i++){
      groups.add(GroupRegister(g[i]));
    }
  }

  _getAccount() async{     
    List<AccountRegister>? account = await AccountConnect().getData(); 
    for(int i=0;i<account!.length;i++){
      RowRegister temp = RowRegister(account[i],columnTitle.length);
      for(int j=0;j<groups.length;j++){
        if(groups[j].group.id==account[i].idGroup){
          groups[j].add(temp);
        }        
      }
    }
  }

  _getRegister() async {    
    try{      
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

  //get periodBalance and accumulatedBalance
  _getBalances() async {
    periodBalance = BalanceRegister("SALDO",columnTitle.length);    
    for(int i=0;i<groups.length;i++){
      await groups[i].updateBalance();
      for(int j=0;j<groups[i].balance.length;j++){
        periodBalance.add(j,groups[i].balance[j].sum);
      }
    }

    accumulatedBalance = BalanceRegister("ACUMULADO",columnTitle.length);
    double lastValue = 0;
    for(int i=0;i<periodBalance.sum.length;i++){
      accumulatedBalance.add(i,periodBalance.sum[i]+lastValue);
      lastValue = accumulatedBalance.sum[i];
    }
  }

  getFirstColumnWidht(){
    return (columnWidth+20)*scalePanel;
  }

  getColumnWidht(){
    return columnWidth*scalePanel;
  }

  getPanelWidth(){
    return columnTitle.length*getColumnWidht();
  }

  getLeftHandSideColumnWidht(){
    return (columnWidth+20)*scalePanel;
  }

  getRightHandSideColumnWidht(){
    return columnWidth*(columnTitle.length)*scalePanel;
  }

  getRowHeight(int index){
    if(groups[index].rowIsShowing){
      return rowHeight*scalePanel;
    }else{
      return 0;
    }    
  }

  getTitleRowHeight(){
    return rowHeight*scalePanel;
  }

  getGroupHeight(int index){
    return (groups[index].rows.length+1) * getTitleRowHeight();
  }

  getRowHeightGap(){
    return rowHeightGap*scalePanel;
  }

  getBackgroundRowTitle(int index){
    /*if(registers[index].account.credit!){
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
    }*/
    return Colors.white;
  }

  getBackGroundRowCell(int index){
    /*if(!registers[index].account.credit!){
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
    }*/
    return Colors.white;
  }

  getForeground(bool credit){
    if(!credit){
      return theme.foregroundEntryCredit;
    }else{
      return theme.foregroundEntryDebt;
    }
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