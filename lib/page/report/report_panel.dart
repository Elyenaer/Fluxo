
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_write/page/accountManagerPage.dart';
import 'package:firebase_write/page/listFinancialRegisterPage.dart';
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
        child: HorizontalDataTable(
          leftHandSideColumnWidth: controller.getLeftHandSideColumnWidht(),
          rightHandSideColumnWidth: controller.getRightHandSideColumnWidht(),
          isFixedHeader: true,
          headerWidgets: _titleItem(context),
          leftSideItemBuilder:  _rowTitle,
          rightSideItemBuilder: _rowPanel,
          itemCount: controller.getRowsQuantity(),
          rowSeparatorWidget: const Divider(
            height: 1.0,
            thickness: 0.0,
          ),
        ),     
      );
  }

  List<Widget> _titleItem(BuildContext context) {    
    List<Widget> title = <Widget>[];

    title.add(Container(     
      color: Theme.of(context).scaffoldBackgroundColor,
      width: controller.getColumnWidht(),
      height: controller.getRowHeight(),
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
    ));
    
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
          height: controller.getRowHeight(),
          alignment: Alignment.center,
          //color: Theme.of(context).appBarTheme.backgroundColor,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        )
      );
    }

    return title;
  }

  Widget _rowTitle(BuildContext context,int index) {
    return Center(
      child: Container(     
        color: controller.getBackgroundRowTitle(index),  
        child: AutoSizeText(
          controller.registers[index].account.description!,
          maxLines: 2,
          minFontSize: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0 * controller.scalePanel,
            color: Colors.white
          )
        ),
        height: controller.getRowHeight(),
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget _rowPanel(BuildContext context,int index) {    
    return Row(
      children: <Widget>[
        SizedBox(
          height: controller.getRowHeight(),          
            child: Row(            
              children: _getRowsPanel(context,controller.registers[index],controller.getBackGroundRowCell(index)),
            ),
          ),
      ],
    );
  }

  List<Widget> _getRowsPanel(BuildContext context,RowRegister r,Color backgroundColor){
    List<Widget> rows = <Widget>[];
    for(int i=0;i<r.register.length;i++){      
      rows.add(
        Container(
          width: controller.getColumnWidht(),
          height: controller.getRowHeight(),
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

}