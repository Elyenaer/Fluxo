
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomFloatingButton extends StatelessWidget{
  CustomFloatingButton({
    Key? key,
    required this.onPressed,
    this.icon
    }) 
    : super(key: key);

  Function() onPressed;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: UniqueKey(),
      child: Icon(icon),      
      onPressed: () {  
        onPressed();
      },
    );
  }

}