
import 'package:firebase_write/custom/widgets/customDateTextField.dart';
import 'package:firebase_write/custom/widgets/customDropDown.dart';
import 'package:firebase_write/help/convert.dart';
import 'package:firebase_write/page/report/report_controller.dart';
import 'package:firebase_write/page/report/report_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types, must_be_immutable
class ReportPage extends StatefulWidget{
  const ReportPage({
    Key? key,
  }) : super(key: key);

   @override
  _MyHomePageState createState() => _MyHomePageState();
}

  // ignore: non_constant_identifier_names
  class _MyHomePageState extends State<ReportPage> {    
    late ReportController controller;
    
  @override
  void initState(){    
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    
    controller = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("RELATÓRIO"),
      ),
      body: controller.state == ReportState.loadingUserPreferences
      ? const Center(child: CircularProgressIndicator())
      : Padding(
        padding:const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[    
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                Flexible(
                  child: CustomDropDown(
                    list: controller.periodList, 
                    selected: controller.periodValue, 
                    change: (value){
                      controller.setPeriod(value);
                    }
                  ),
                ),
                const SizedBox(width: 30,),
                Flexible(
                  child: CustomDateTextField(
                    controller: controller.tecDateStart,
                    label: 'Data Inicial',
                    function: () {
                      controller.update();                    
                    }
                  ),
                ),
                const SizedBox(width: 30,),
                Flexible(
                  child: CustomDateTextField(
                    controller: controller.tecDateEnd,
                    label: 'Data Final',
                    function: () {
                      controller.update();                    
                    }
                  ),
                ),          
              ]
            ),  
            const SizedBox(height: 20,),
            Expanded(
              child:Row(
                children: [
                  Expanded(
                    child: ReportPanel(controller: controller),
                  ),
                ]
              )
            ),
            _sliderScale(controller),     
          ],
        ),
      ),
    );
  }

  Widget _sliderScale(ReportController controller){
    return Slider(
      value: controller.scalePanel,
      max: 3.0,
      min: 0.1,
      divisions: 29,
      label: convert.percent(controller.scalePanel,1.0,0),
      onChanged: (double value) {
        controller.setScale(value);
      },
    );
  }

}
