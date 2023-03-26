
import 'package:firebase_write/help/message.dart';
import 'package:firebase_write/models/account/account_register.dart';
import 'package:firebase_write/models/account_group/account_group_controller.dart';
import 'package:firebase_write/models/account_group/account_group_register.dart';
import 'package:firebase_write/models/financial_entry/financial_entry_register.dart';
import 'package:firebase_write/models/user/user_preferences/user_preferences_register.dart';
import 'package:firebase_write/page/report/balance_register.dart';
import 'package:firebase_write/page/report/group_register.dart';
import 'package:firebase_write/page/report/row_register.dart';
import 'package:firebase_write/settings/manager_access/current_access/current_access.dart';
import 'package:flutter/material.dart';
import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/help/funcDate.dart';
import 'package:firebase_write/models/theme/theme_controller.dart';
import 'package:intl/intl.dart';
import '../../models/financial_entry/financial_entry_connect.dart';
import '../../models/account/account_connect.dart';

enum ReportState {loadingUserPreferences,loadingPanelData,loaded}

class ReportController with ChangeNotifier {
  var state = ReportState.loadingUserPreferences;
  late UserPreferencesRegister? userPreferences;

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

  ReportController() {
    initState();    
  }

  Future<void> initState() async {     
    await _getUserPreferences();    
    await update();
  }

/*
  _savePreferences() async {
    userPreferences.start_date_report = convert.StringToDatetime(tecDateStart.text);
    userPreferences.end_date_report = convert.StringToDatetime(tecDateEnd.text);
    userPreferences.scale = scalePanel;
    userPreferences.period_report = periodValue;

    await UserPreferencesConnect().update(userPreferences);
  }
*/

  update() async {       
    _setState(ReportState.loadingPanelData);
    await _getColumnTitle(); 
    await _getGroup();
    await _getAccount();
    await _getRegister();
    await _getBalances();
    _setState(ReportState.loaded);
  }

  _getUserPreferences() async {
    userPreferences = CurrentAccess.userPreferences;
    tecDateStart.text = DateFormat('dd/MM/yyyy').format(userPreferences!.start_date_report!);
    tecDateEnd.text = DateFormat('dd/MM/yyyy').format(userPreferences!.end_date_report!);   
    scalePanel = userPreferences!.scale!;
    periodValue = userPreferences!.period_report!;  
  }

  _setState(var s){
    state = s;
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
      if(g[i].accounts==null || g[i].accounts!.isEmpty){
        continue;
      }
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

    //order
    for(int i=0;i<groups.length;i++){
      groups[i].sort();      
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
          if(reg[i].date!.isAfter(d2)){
            break;
          }else if(reg[i].date!.isBefore(d)){
            continue;
          }
          for(int j=0;j<groups.length;j++){
            for(int x=0;x<groups[j].rows.length;x++){
              if(reg[i].idAccount==groups[j].rows[x].account.id){
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
    }catch(e){
      debugPrint('REPORT CONTROLLER ERRO _GETREGISTER -> $e');
      return '';
    }
  }

  //get periodBalance and accumulatedBalance
  _getBalances() async {
    try{
      periodBalance = BalanceRegister("Saldo",columnTitle.length);   
      for(int i=0;i<groups.length;i++){
        await groups[i].updateBalance();
        for(int j=0;j<groups[i].balance.length;j++){
          periodBalance.add(j,groups[i].balance[j].sum);
        }
      }

      accumulatedBalance = BalanceRegister("Acumulado",columnTitle.length);
      double lastValue = 0;
      for(int i=0;i<periodBalance.sum.length;i++){
        accumulatedBalance.add(i,periodBalance.sum[i]+lastValue);
        lastValue = accumulatedBalance.sum[i];
      }
    }catch(e){
      message.error(runtimeType,StackTrace.current,"_getBalances",e);
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
    if(groups[index].rowIsShowing){
      return (groups[index].rows.length+1) * getTitleRowHeight();
    }else{
      return getTitleRowHeight();
    }    
  }

  getRowHeightGap(){
    return rowHeightGap*scalePanel;
  }

  getBackgroundRowTitle(int groupIndex,int rowIndex){
    if(!groups[groupIndex].rows[rowIndex].account.credit!){
      if(rowIndex % 2 == 0){
        return ThemeController.backgroundTitleDebt1;
      }else{
        return ThemeController.backgroundTitleDebt2;
      }
    }else{
      if(rowIndex % 2 == 0){
        return ThemeController.backgroundTitleCredit1;
      }else{
        return ThemeController.backgroundTitleCredit2;
      }
    }
  }

  getBackGroundRowCell(int groupIndex,int rowIndex){
    if(groups[groupIndex].rows[rowIndex].account.credit!){
      if(rowIndex % 2 == 0){
        return ThemeController.backgroundEntryCredit1;
      // ignore: dead_code
      }else{
        return ThemeController.backgroundEntryCredit2;
      }
    }else{
      if(rowIndex % 2 == 0){
        return ThemeController.backgroundEntryDebt1;
      // ignore: dead_code
      }else{
        return ThemeController.backgroundEntryDebt2;
      }
    }
  }

  getBackgroundBalance(double value){
    if(value<0){
      return ThemeController.backgroundBalanceDebt;
    }else{
      return ThemeController.backgroundBalanceCredit;
    }
  }

  getForeground(bool credit){
    if(credit){
      return ThemeController.foregroundEntryCredit;
    }else{
      return ThemeController.foregroundEntryDebt;
    }
  }

  getTitleForeground(int groupIndex,int rowIndex){
    if(groups[groupIndex].rows[rowIndex].account.credit!){
      return ThemeController.foregroundTitleCredit;
    }else{
      return ThemeController.foregroundTitleDebt;
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

  setGroupRowIsShowing(int index){
    groups[index].rowIsShowing = !groups[index].rowIsShowing;
    notifyListeners();
  }

}
