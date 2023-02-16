// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: camel_case_types, must_be_immutable
class dateWidget extends StatefulWidget{
  TextEditingController tec = TextEditingController(text: '');
  
  dateWidget(
    {
      Key? key,
      TextEditingController? tec
    }
  )
  : super(key: key){
    this.tec = tec!;
  }

  @override
  // ignore: no_logic_in_create_state
  _MyHomePageState createState() => _MyHomePageState(tec);
}

class _MyHomePageState extends State<dateWidget> {
  TextEditingController tec = TextEditingController(text: '');

  _MyHomePageState(this.tec);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Flexible(            
            child: FloatingActionButton(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.grey,
              onPressed: () {
                
                
                _showDate(context);
                
                /*
                DateTime? pickeddate = showDatePicker(
                  context: context, 
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000), 
                  lastDate: DateTime(2100)) as DateTime?;
                  if (pickeddate != null){
                    setState(() {
                      tec.text =  DateFormat('dd/MM/yyyy').format(pickeddate);
                    });
                  }*/
                },   
              child: const Icon(Icons.calendar_today_rounded),
            ),
          ),
          Expanded(
            child: TextField(     
              controller: tec,         
              keyboardType: TextInputType.number,
              inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Data Inicial"
              ),
            ),  
          ),
        ]
      ),
    );
  }

  void _showDate(BuildContext context){  

  }


}