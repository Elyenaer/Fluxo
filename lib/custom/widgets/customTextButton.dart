import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextButton extends StatefulWidget{
  CustomTextButton ({
    Key? key,
    required this.onPressed,
    required this.text,
    this.foregroundColor,
    this.fontSize,
    this.fontWeight
  }) : super(key: key);

  Function() onPressed;
  String text;
  Color? foregroundColor;
  double? fontSize;
  FontWeight? fontWeight;

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

  // ignore: non_constant_identifier_names
  class _MyHomePageState extends State<CustomTextButton > {

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {  
        widget.onPressed();
      },
      style: ButtonStyle(
        alignment: Alignment.centerLeft,
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.zero, 
        ),
      ),
      child: Text(
        widget.text,
        style: TextStyle(            
          color: widget.foregroundColor ??= Theme.of(context).primaryColor,
          fontSize: widget.fontSize ??= 16.0,
          fontWeight: widget.fontWeight ??= FontWeight.normal
        ),        
      )
    );
  }

}
