
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_write/page/accountManagerPage.dart';
import 'package:firebase_write/page/listFinancialRegisterPage.dart';
import 'package:firebase_write/page/report/balance_register.dart';
import 'package:firebase_write/page/report/group_register.dart';
import 'package:firebase_write/page/report/report_controller.dart';
import 'package:firebase_write/page/report/row_register.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:firebase_write/help/convert.dart';

// ignore: must_be_immutable
class ReportPanel extends StatelessWidget{
  ReportPanel({
    Key? key,
    required this.controller,
    }) : super(key: key);

  ReportController controller;

  @override
  Widget build(BuildContext context) {    
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
        ),
      height: MediaQuery.of(context).size.height-200,        
      child: controller.state == ReportState.loading 
      ? const Center(child: CircularProgressIndicator())
      : HorizontalDataTable(
          leftHandSideColumnWidth: controller.getLeftHandSideColumnWidht(),
          rightHandSideColumnWidth: controller.getRightHandSideColumnWidht(),
          isFixedHeader: true,
          headerWidgets: _titleItem(context),
          leftSideItemBuilder:  _rowGroupLeft,
          rightSideItemBuilder: _rowGroupRight,
          itemCount: controller.groups.length+1,
          rowSeparatorWidget: const Divider(
            height: 1.0,
            thickness: 0.0,
          ),
        ),     
    );
  }

  List<Widget> _titleItem(BuildContext context) {    
    List<Widget> title = <Widget>[];

    title.add(
      Container(     
        color: Theme.of(context).scaffoldBackgroundColor,
        width: controller.getFirstColumnWidht(),
        height: controller.getTitleRowHeight(),
        child: Transform.scale(
          scale: controller.scalePanel,
          child: IconButton(           
            onPressed: () {
              final updateCheck = Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => 
                  const AccountManagerPage()),
              );   
              updateCheck.then((value) {
                if(value=="update"){
                  
                }   
              });    
            },      
            icon: Icon(
              Icons.schema_outlined,
              color: Theme.of(context).primaryColor,
            ),
          )
        )
      )
    );
    
    for(int i=0;i<controller.columnTitle.length;i++){
      title.add(
        Container(     
          color: Theme.of(context).appBarTheme.backgroundColor,
            child: AutoSizeText(
              controller.columnTitle[i], 
              textAlign: TextAlign.center,
              maxLines: 3,
              minFontSize: 1,
              style: TextStyle(
                color: Theme.of(context).appBarTheme.foregroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 15.0 * controller.scalePanel
              )
          ),
          width: controller.getColumnWidht(),
          height: controller.getTitleRowHeight(),
          alignment: Alignment.center,
          //color: Theme.of(context).appBarTheme.backgroundColor,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        )
      );
    }

    return title;
  }

  Widget _rowGroupLeft(BuildContext context,int index){
    return Column(
      children:_rowTitle(context,index),
    );
  }

  _rowTitle(BuildContext context,int index) {

    //go to balance rows
    if(index>=controller.groups.length){
      return _rowTitleBalance(context);
    }

    GroupRegister group = controller.groups[index];    
    List<Widget> titles = <Widget>[];
    for(int i=0;i<group.rows.length;i++){
      titles.add(
        Center(
          child: Container(     
            color: controller.getBackgroundRowTitle(i),  
            child: AutoSizeText(
              group.rows[i].account.description!,
              maxLines: 2,
              minFontSize: 1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0 * controller.scalePanel,
                color: Colors.black
              )
            ),
            height: controller.getTitleRowHeight(),
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
        )
      );
    }

    titles.add(Center(
      child: Container(     
        //color: controller.getBackgroundRowTitle(i),  
        child: AutoSizeText(
          group.group.description!,
          maxLines: 2,
          minFontSize: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0 * controller.scalePanel,
            color: Colors.black
          )
        ),
        height: controller.getTitleRowHeight(),
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
      ),
    )
  );

    return titles;
  }

  Widget _rowGroupRight(BuildContext context,int index) {    
    return Row(
      children: [
        SizedBox(
          child: Column(            
            children: _rowPanel(context,index),
          ),
        ),
      ],
    );
  }
 
  List<Widget> _rowPanel(BuildContext context,int index) {  
    List<Widget> rows = [];
    if(index>=controller.groups.length){
      rows.add(
        SizedBox(
          height: controller.getTitleRowHeight(),     
          width: controller.getPanelWidth(),     
          child: Center(
            child: Row(          
              children: _getRowsPanelBalance(context, controller.periodBalance),
            ),
          ),
        ),
      );
      rows.add(
        SizedBox(
          height: controller.getTitleRowHeight(),        
          width: controller.getPanelWidth(),     
          child: Center(
            child: Row(          
              children: _getRowsPanelBalance(context, controller.accumulatedBalance),
            ),
          ),
        ),
      );
      return rows;
    }

    GroupRegister group = controller.groups[index];    
    for(int i=0;i<group.rows.length;i++){
      rows.add(
        SizedBox(
          height: controller.getRowHeight(index),     
          width: controller.getPanelWidth(),     
          child: Center(
            child: Row(          
              children: _getRowsPanel(context,group.rows[i],controller.getBackGroundRowCell(i)),
            ),
          ),
        ),
      );
    }

    rows.add(
        SizedBox(
          height: controller.getRowHeight(index),     
          width: controller.getPanelWidth(),     
          child: Center(
            child: Row(          
              children: _getGroupRowsPanel(context,group,Colors.green),
            ),
          ),
        ),
      );

    return rows;
  }

  List<Widget> _getRowsPanel(BuildContext context,RowRegister r,Color backgroundColor){
    List<Widget> rows = <Widget>[];
    for(int i=0;i<r.register.length;i++){      
      rows.add(
        Container(
          width: controller.getColumnWidht(),
          height: controller.getTitleRowHeight(),
          color: backgroundColor,
          child: TextButton(       
            child: AutoSizeText(                            
              convert.doubleToCurrencyBR(r.register[i].sum),
              minFontSize: 1,
              maxLines: 1,
              style: TextStyle(
                color: controller.getForeground(r.account.credit!),
                fontSize: 15.0 * controller.scalePanel           
              ),
            ),
            onPressed: () {
              final updateCheck = Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => 
                  ListFinancialRegisterPage(
                    backgroundTitle: controller.getBackgroundRowTitle(i),
                    account: r.account,
                    title: controller.columnTitle[i],
                    start: controller.start,
                    end: controller.end,
                    registers: r.register[i].cellRegister,
                  )
                ),
              );
              updateCheck.then((value) {
                if(value.toString()=="update"){
                    controller.update();
                }
              });
            },              
          ),
        ),
      );
    }        
    return rows;
  }

  List<Widget> _getGroupRowsPanel(BuildContext context,GroupRegister r,Color backgroundColor){
    List<Widget> rows = <Widget>[];
    for(int i=0;i<r.balance.length;i++){      
      rows.add(
        Container(
          width: controller.getColumnWidht(),
          height: controller.getTitleRowHeight(),
          color: backgroundColor,
          child: TextButton(       
            child: AutoSizeText(                            
              convert.doubleToCurrencyBR(r.balance[i].sum),
              minFontSize: 1,
              maxLines: 1,
              style: TextStyle(
                //color: controller.getForeground(r.account.credit!),
                fontSize: 15.0 * controller.scalePanel           
              ),
            ),
            onPressed: () {
              
            },              
          ),
        ),
      );
    }        
    return rows;
  }

  List<Widget> _rowTitleBalance(BuildContext context) {
    List<Widget> titles = <Widget>[];
    titles.add(
      Center(
        child: Container(     
          color: Colors.blue,  
          child: AutoSizeText(
            controller.periodBalance.description,
            maxLines: 2,
            minFontSize: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0 * controller.scalePanel,
              color: Colors.black
            )
          ),
          height: controller.getTitleRowHeight(),
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      )
    );

    titles.add(
      Center(
        child: Container(     
          color: Colors.blue,  
          child: AutoSizeText(
            controller.accumulatedBalance.description,
            maxLines: 2,
            minFontSize: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0 * controller.scalePanel,
              color: Colors.black
            )
          ),
          height: controller.getTitleRowHeight(),
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      )
    );

    return titles;
    }
  
  List<Widget> _getRowsPanelBalance(BuildContext context,BalanceRegister r){
    List<Widget> rows = <Widget>[];
    for(int i=0;i<r.sum.length;i++){      
      rows.add(
        SizedBox(
          width: controller.getColumnWidht(),
          height: controller.getTitleRowHeight(),
          //color: backgroundColor,
          child: TextButton(       
            child: AutoSizeText(                            
              convert.doubleToCurrencyBR(r.sum[i]),
              minFontSize: 1,
              maxLines: 1,
              style: TextStyle(
                //color: controller.getForeground(r.account.credit!),
                fontSize: 15.0 * controller.scalePanel           
              ),
            ),
            onPressed: () {
              
            },              
          ),
        ),
      );
    }        
    return rows;
  }

}