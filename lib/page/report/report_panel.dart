
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_write/custom/widgets/customTextButton.dart';
import 'package:firebase_write/page/account_manager/account_manager_page.dart';
import 'package:firebase_write/page/list_financial_register/list_financial_register_page.dart';
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
      child: controller.state != ReportState.loaded
      ? const Center(child: CircularProgressIndicator())
      : HorizontalDataTable(
          leftHandSideColumnWidth: controller.getLeftHandSideColumnWidht(),
          rightHandSideColumnWidth: controller.getRightHandSideColumnWidht(),
          isFixedHeader: true,
          headerWidgets: _titleItem(context),
          leftSideItemBuilder:  _rowGroupLeft,
          rightSideItemBuilder: _rowGroupRight,
          itemCount: controller.groups.length+1,
        ),     
    );
  }

  List<Widget> _titleItem(BuildContext context) {    
    List<Widget> title = <Widget>[];

    title.add(
      Container(     
        color: Theme.of(context).appBarTheme.backgroundColor,
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
                  controller.update();              
                }   
              });    
            },      
            icon: Icon(
              Icons.schema_outlined,
              color: Theme.of(context).appBarTheme.foregroundColor,
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
    List<Widget> titles = <Widget>[];

    //go to balance rows
    if(index>=controller.groups.length){
      titles.add(_rowTitleBalance(context,controller.periodBalance));
      titles.add(_rowTitleBalance(context,controller.accumulatedBalance));
      return titles;
    }

    if(controller.groups[index].rowIsShowing){
      for(int i=0;i<controller.groups[index].rows.length;i++){
        titles.add(
          Center(
            child: Container( 
              height: controller.getTitleRowHeight(),
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,    
              color: controller.getBackgroundRowTitle(index,i),  
              child: CustomTextButton(
                text: controller.groups[index].rows[i].account.description!,                
                maxLines: 2,
                foregroundColor: controller.getTitleForeground(index,i),
                fontWeight: FontWeight.bold,
                fontSize: 15.0 * controller.scalePanel,
                onPressed: () {}, 
              ),            
            ),
          )
        );
      }
    }    

    titles.add(
      Center(
        child: Container(    
          height: controller.getTitleRowHeight(),
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: Theme.of(context).appBarTheme.backgroundColor,
          child: CustomTextButton(
            text: controller.groups[index].group.description!,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            maxLines: 2,
            fontWeight: FontWeight.bold,
            fontSize: 15.0 * controller.scalePanel,
            onPressed: () {
              controller.setGroupRowIsShowing(index);            
            },
          ),
        ),
      )
    );

    //put spaces between spaces
    titles.add(_blankSpace(1));

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

    //check if index is heading to balance and accumulated
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

    //check if rows from group is showing
    if(group.rowIsShowing){
      for(int i=0;i<group.rows.length;i++){
        rows.add(
          SizedBox(
            height: controller.getRowHeight(index),     
            width: controller.getPanelWidth(),     
            child: Center(
              child: Row(          
                children: _getRowsPanel(context,group.rows[i],controller.getBackGroundRowCell(index,i)),
              ),
            ),
          ),
        );
      }
    }      

    //include balance of group
    rows.add(
        SizedBox(
          height: controller.getTitleRowHeight(),     
          width: controller.getPanelWidth(),     
          child: Center(
            child: Row(          
              children: _getGroupRowsPanel(context,group),
            ),
          ),
        ),
      );

    rows.add(_blankSpace(controller.columnTitle.length));

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
          child: CustomTextButton(                         
            text: convert.doubleToCurrencyBR(r.register[i].sum),
            foregroundColor: controller.getForeground(r.account.credit!),
            fontSize: 15.0 * controller.scalePanel,  
            onPressed: () {
              final updateCheck = Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => 
                  ListFinancialRegisterPage(
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

  List<Widget> _getGroupRowsPanel(BuildContext context,GroupRegister r){
    List<Widget> rows = <Widget>[];
    for(int i=0;i<r.balance.length;i++){      
      rows.add(
        Container(
          width: controller.getColumnWidht(),
          height: controller.getTitleRowHeight(),
          color: controller.getBackgroundBalance(r.balance[i].sum),
          child: CustomTextButton(
            text: convert.doubleToCurrencyBR(r.balance[i].sum),
            fontSize: 15.0 * controller.scalePanel,
            fontWeight: FontWeight.bold,
            foregroundColor: Colors.white,
            onPressed: () {}
          ),
        ),
      );
    }        
    return rows;
  }

  _rowTitleBalance(BuildContext context,BalanceRegister b) {
    return Center(
        child: Container(   
          height: controller.getTitleRowHeight(),
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,  
          color: Theme.of(context).appBarTheme.backgroundColor,  
          child: CustomTextButton(
            text: b.description,
            fontWeight: FontWeight.bold,
            fontSize: 15.0 * controller.scalePanel,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            onPressed: () {},          
          ),          
        ),
      );
  }
  
  List<Widget> _getRowsPanelBalance(BuildContext context,BalanceRegister r){
    List<Widget> rows = <Widget>[];
    for(int i=0;i<r.sum.length;i++){      
      rows.add(
        Container(
          width: controller.getColumnWidht(),
          height: controller.getTitleRowHeight(),
          color: controller.getBackgroundBalance(r.sum[i]),
          child: CustomTextButton(
            text: convert.doubleToCurrencyBR(r.sum[i]),            
            fontSize: 15.0 * controller.scalePanel,  
            fontWeight: FontWeight.bold,
            foregroundColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }        
    return rows;
  }

  //put space between groups
  _blankSpace(int quantity){
    List<Widget> space = [];
    for(int i=0;i<quantity;i++){
      space.add(
        SizedBox(
          height: controller.getRowHeightGap(),
        )
      );
    }
    return Row(
      children: space
    );
  }

}