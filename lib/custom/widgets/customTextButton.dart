import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextButton extends StatelessWidget{
  CustomTextButton ({
    Key? key,
    required this.onPressed,
    required this.text,
    this.foregroundColor,
    this.fontSize,
    this.fontWeight,
    this.maxLines,
    this.alignment,
    this.fixedSizeText
  }) : super(key: key);

  Function() onPressed;
  String text;
  Color? foregroundColor;
  double? fontSize;
  FontWeight? fontWeight;
  int? maxLines;
  Alignment? alignment;
  bool? fixedSizeText = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {  
        onPressed();
      },
      style: ButtonStyle(
        alignment: alignment ??= Alignment.center,
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.zero, 
        ),
      ),
      child:_Text(context)
    );
  }

  // ignore: non_constant_identifier_names
  Widget _Text(BuildContext context){
    if(fixedSizeText!=null && fixedSizeText==true){
      return Text(
        text,
        maxLines: maxLines ??= 1,
        style: TextStyle(            
          color: foregroundColor ??= Theme.of(context).primaryColor,
          fontSize: fontSize ??= 16.0,
          fontWeight: fontWeight ??= FontWeight.normal
        ),        
      );
    }else{
      return AutoSizeText(
        text,
        minFontSize: 1,
        maxLines: maxLines ??= 1,
        style: TextStyle(            
          color: foregroundColor ??= Theme.of(context).primaryColor,
          fontSize: fontSize ??= 16.0,
          fontWeight: fontWeight ??= FontWeight.normal
        ),        
      );
    }
  }

}
