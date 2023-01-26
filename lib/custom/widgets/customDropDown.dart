
import 'package:flutter/material.dart';

// ignore: camel_case_types, must_be_immutable
class CustomDropDown extends StatefulWidget{
  CustomDropDown({
    Key? key,
    required this.list,
    required this.selected,
    this.add,
    this.icon,
    required this.change
  }) : super(key: key);

  List<String> list;
  String selected;
  Function()? add;
  Function(String) change;
  IconData? icon;

   @override
  // ignore: no_logic_in_create_state
  _MyHomePageState createState() => _MyHomePageState();
}

  // ignore: non_constant_identifier_names
  class _MyHomePageState extends State<CustomDropDown> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _Components(),
    );
  }

  // ignore: non_constant_identifier_names
  List<Widget> _Components(){
    List<Widget> l = <Widget>[];

    if(widget.icon!=null){
      l.add(
        Icon(
          widget.icon,
          size: 25,
          color: Theme.of(context).inputDecorationTheme.iconColor,
        ),
      );
      l.add(
        const SizedBox(
            width: 20,
        ),
      );
    }
    l.add(_List());
    if(widget.add!=null){
      l.add(
        const SizedBox(
            width: 10,
        ),
      );
      l.add(_buttonIncludeType());
    }    

    return l;
  }

  // ignore: non_constant_identifier_names
  Widget _List(){
    return Expanded(
      child: DropdownButton<String>(
        value: widget.selected,
        icon: const Icon(Icons.arrow_drop_down),
        isExpanded: true,
        underline: Container(
          height: 2,
          color: Theme.of(context).primaryColor,
        ),
        onChanged: (String? value) {            
          value !=null ? widget.change(value) : null;
        },
        items: widget.list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

    Widget _buttonIncludeType() {
      return Flexible(
        child: FloatingActionButton(
          heroTag: UniqueKey(),
          onPressed: () {
            widget.add!();
          },
          child: const Icon(Icons.add),
        ),
      );
  }

}




