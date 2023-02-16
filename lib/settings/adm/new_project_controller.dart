
import 'package:flutter/material.dart';

enum NewProjectState {loading,loaded}

class NewProjectController with ChangeNotifier {
  var state = NewProjectState.loaded;
  TextEditingController tecId = TextEditingController(text: '');  
  TextEditingController tecName = TextEditingController(text: '');    
  TextEditingController tecTextArea = TextEditingController(text: '');

  NewProjectController(){


  }

  _setState(NewProjectState s){
    state = s;
    notifyListeners();
  }
  




}