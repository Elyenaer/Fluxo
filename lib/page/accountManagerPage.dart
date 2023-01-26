
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:firebase_write/custom/widgets/customTextButton.dart';
import 'package:firebase_write/custom/widgets/customTextField.dart';
import 'package:firebase_write/database.dart/connection/accountConnect.dart';
import 'package:firebase_write/database.dart/connection/accountGroupConnect.dart';
import 'package:firebase_write/database.dart/register/accountGroupRegister.dart';
import 'package:firebase_write/database.dart/register/accountRegister.dart';
import 'package:firebase_write/help/message.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_write/settings/theme.dart';

class AccountManagerPage extends StatefulWidget {
  const AccountManagerPage({Key? key}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<AccountManagerPage> {
  late List<DragAndDropList> lists;
  final List<_Group> _allLists = <_Group>[];
  bool _isLoading = true;

  @override
  initState() {    
    super.initState();
    _getAccount();        
  }

  _getAccount() async {
    List<AccountGroupRegister>? group = await AccountGroupConnect().getData();
    List<AccountRegister>? account = await AccountConnect().getData();

    for(int i=0;i<group!.length;i++){
      List<AccountRegister> _items = <AccountRegister> [];
      for(int j=0;j<account!.length;j++){
        if(group[i].id==account[j].idGroup){
          _items.add(account[j]);
        }
      }
      _allLists.add(_Group(
        group: group[i], 
        accounts: _items
      ));
    }    
    _updateList();
    setIsloading(false);
  } 

  _updateList(){    
    // ignore: prefer_function_declarations_over_variables
    Comparator<_Group> sortbyId = (a, b) => a.group.sequence!.compareTo(b.group.sequence!);   
    _allLists.sort(sortbyId);
    lists = _allLists.map(_groupPanel).toList();
  }


  void setIsloading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  } 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CONTAS'),
        centerTitle: true,
      ),
      body: _isLoading
        ? const Center(
            child: CircularProgressIndicator()
          )
        : Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column( 
            children: [
              Flexible(
                child: DragAndDropLists(                  
                  lastItemTargetHeight: 0,
                  listPadding: const EdgeInsets.all(16),
                  listInnerDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  children: lists,
                  itemDivider: Divider(
                    thickness: 2, 
                    height: 2,
                    color: Theme.of(context).scaffoldBackgroundColor
                  ),
                  itemDecorationWhileDragging: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.secondary,
                        blurRadius: 10
                      )
                    ],
                  ),
                  listDragHandle: buildDragHandle(isList: true),
                  itemDragHandle: buildDragHandle(),
                  onItemReorder: onReorderListItem,
                  onListReorder: onReorderList,
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      
                    }, 
                    child: const Text("+ GRUPO")
                  ),
                  ElevatedButton(
                    onPressed: () {
                      
                    }, 
                    child: const Text("SALVAR ALTERAÇÕES")
                  ),
                ],
              )
              
            ]
          )
        )
    );
  }

  DragHandle buildDragHandle({bool isList = false}) {
    final verticalAlignment = isList
      ? DragHandleVerticalAlignment.top
      : DragHandleVerticalAlignment.center;
    final color = isList
      ? Theme.of(context).colorScheme.secondary
      : Theme.of(context).colorScheme.primary;

    return DragHandle(
      verticalAlignment: verticalAlignment,
      child: Container(
        padding: const EdgeInsets.fromLTRB(0,10,10,0),
        child: FaIcon(
          FontAwesomeIcons.upDown,
          size: 20,
          color: color),
      ),
    );
  }

  DragAndDropList _groupPanel(_Group group){
    group.sort();    
    return DragAndDropList(
      header: Container(
        padding: const EdgeInsets.all(8),
        child: CustomTextButton(
          text: group.group.description!,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          onPressed: () async {
            group.group.description 
              = await message.changeText(context,'',group.group.description!);
            setState(() { 
              _updateList();
            });
          },
        ),
      ),
      children: group.accounts.map(_accountPanel).toList(),
      footer: Row(
        children: _groupButtons(group),
      ),
    );
  }

  List<Widget> _groupButtons(_Group group){
    List<Widget> b = <Widget>[];
    b.add(
      IconButton(
        icon: Icon(
          Icons.add_box_rounded,
          color: Theme.of(context).primaryColor,
        ),
        iconSize: 25,
        onPressed: () async { 
          group.group.description 
              = await _accountRegister(context,'',group.group.description!);
            setState(() { 
              //_updateList();
            });
          
        },
      ),
    );


    //print(group.group.description.toString() + " -> " + group.accounts.length.toString());


    if(group.accounts.isEmpty){
      b.add(
        IconButton(
          icon: Icon(
            Icons.delete,
            color: theme.foregroundEntryDebt,
          ),
          iconSize: 25,
          onPressed: () { 

          },
        ),
      );
    }

    return b;
  }

  DragAndDropItem _accountPanel(AccountRegister register){
    return DragAndDropItem(
      child: register.credit!
      ? ListTile(
        leading: Icon(
          Icons.attach_money,
          color: theme.foregroundEntryCredit,
        ), 
        title: CustomTextButton(
          text: register.description!,
          onPressed: () {  

          },
          foregroundColor: theme.foregroundEntryCredit,
        ),
        trailing: const SizedBox(width: 20,),
      )
      : ListTile(
        leading:  Icon(
          Icons.money_off,
          color: theme.foregroundEntryDebt,
        ), 
        title: CustomTextButton(
          text: register.description!,
          onPressed: () {  

          },
          foregroundColor: theme.foregroundEntryDebt,
        ),
        trailing: const SizedBox(width: 20,),
      )
    );
  }

  void onReorderListItem(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      final oldListItems = lists[oldListIndex].children;
      final newListItems = lists[newListIndex].children;

      final movedItem = oldListItems.removeAt(oldItemIndex);
      newListItems.insert(newItemIndex, movedItem);
    });
  }

  void onReorderList(
    int oldListIndex,
    int newListIndex,
  ) {
    setState(() {
      final movedList = lists.removeAt(oldListIndex);
      lists.insert(newListIndex, movedList);
    });
  }

}

class _Group {
  AccountGroupRegister group;
  List<AccountRegister> accounts;

  _Group({
    required this.group,
    required this.accounts,
  });

  sort(){
    // ignore: prefer_function_declarations_over_variables
    Comparator<AccountRegister> sortById = (a, b) => a.groupSequence!.compareTo(b.groupSequence!);
    accounts.sort(sortById);
  }

}

_accountRegister(BuildContext context,String title,String text) async { 

  TextEditingController _tecId = TextEditingController(text: text);
  TextEditingController _tecDescription = TextEditingController(text: text);


  Widget okButton = FloatingActionButton(
    child: const Text("OK"),
    onPressed: () { 
       Navigator.of(context).pop(_tecDescription.text);
    },
  );
  
  Widget textField = Column(
    children: [
      Row(
        children: [
          CustomTextField(controller: _tecId),
          
        ],
      ),
      CustomTextField(controller: _tecDescription)
    ],
  );

  AlertDialog m = AlertDialog(
    title: Text(title),
    content: textField,
    actions: [
      okButton,
    ],
  );

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return m;
    },
  );

  return _tecDescription.text;
}