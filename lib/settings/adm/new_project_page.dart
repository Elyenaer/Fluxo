
// ignore: camel_case_types, must_be_immutable
import 'package:firebase_write/custom/widgets/customTextButton.dart';
import 'package:firebase_write/custom/widgets/customTextField.dart';
import 'package:firebase_write/settings/adm/new_project_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewProjectPage extends StatefulWidget{
  const NewProjectPage({
    Key? key,
  }) : super(key: key);

   @override
  _MyHomePageState createState() => _MyHomePageState();
}

  // ignore: non_constant_identifier_names
  class _MyHomePageState extends State<NewProjectPage> {    
    late NewProjectController controller;
    
  @override
  void initState(){    
    super.initState();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    
    controller = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADM'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50) ,
        child: Column(
          children: [
            Row(
              children: [
                CustomTextField(
                  controller: controller.tecId
                ),
                Expanded(
                  child: CustomTextField(
                    controller: controller.tecName
                  ),
                ),
              ],
            ),            
            CustomTextField(
              controller: controller.tecTextArea,
              maxLines: 10,
            ),
            const SizedBox(height: 100,),
            CustomTextButton(
              onPressed: () {
                
              },
              text: "CRIAR PROJETO",
            )
          ]
        ),        
      )
    );
  }

}