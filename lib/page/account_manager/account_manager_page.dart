
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:firebase_write/custom/widgets/customTextButton.dart';
import 'package:firebase_write/models/account/accountRegister.dart';
import 'package:firebase_write/help/message.dart';
import 'package:firebase_write/page/account_manager/account_group_register_dialog.dart';
import 'package:firebase_write/page/account_manager/account_manager_controller.dart';
import 'package:firebase_write/page/account_manager/account_manager_group_register.dart';
import 'package:firebase_write/page/account_manager/account_register_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_write/settings/theme.dart';
import 'package:provider/provider.dart';

import '../../models/account_group/account_group_connect.dart';

class AccountManagerPage extends StatefulWidget {
  const AccountManagerPage({Key? key}) : super(key: key);

  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<AccountManagerPage> {
  late List<DragAndDropList> lists;
  late AccountManagerController controller;
  
  @override
  Widget build(BuildContext context) {
    controller = Provider.of(context);
    lists = controller.allLists.map(_groupPanel).toList();
    return Scaffold(
      appBar: AppBar(
        leading: FloatingActionButton(
          elevation: 0,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          child: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop("update");          
          },
        ),
        title: const Text('CONTAS'),
        centerTitle: true,
      ),
      body: controller.state == AccountManagerState.loading
        ? const Center(
            child: CircularProgressIndicator()
          )
        : Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column( 
            children: [
              Flexible(
                child: DragAndDropLists(                  
                  lastItemTargetHeight: 5,
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
              ElevatedButton(
                onPressed: () async {
                  await AccountGroupRegisterDialog(context,controller.allLists.length); 
                  controller.update();          
                }, 
                child: const Text("+ GRUPO")
              ),           
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

  DragAndDropList _groupPanel(AccountManagerGroupRegister managerGroup){
    managerGroup.sort();    
    return DragAndDropList(
      header: Container(
        padding: const EdgeInsets.all(8),
        child: CustomTextButton(
          text: managerGroup.group.description!,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          onPressed: () async {
            managerGroup.group.description 
              = await message.changeText(context,'',managerGroup.group.description!);
            controller.updateGroup(managerGroup.group);
          },
        ),
      ),
      children: managerGroup.accounts.map(_accountPanel).toList(),
      footer: Row(
        children: _groupButtons(managerGroup),
      ),
    );
  }

  List<Widget> _groupButtons(AccountManagerGroupRegister group){
    List<Widget> b = <Widget>[];
    b.add(
      IconButton(
        icon: Icon(
          Icons.add_box_rounded,
          color: Theme.of(context).primaryColor,
        ),
        iconSize: 25,
        onPressed: () async { 
          group.group.description = await AccountRegisterDialog(
            context,null,group.group.id,group.accounts.length);
            controller.update();
        },
      ),
    );

    if(group.accounts.isEmpty){
      b.add(
        IconButton(
          icon: Icon(
            Icons.delete,
            color: theme.foregroundEntryDebt,
          ),
          iconSize: 25,
          onPressed: () { 
            controller.deleteGroup(context, group);            
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
          theme.creditIcon,
          color: theme.foregroundEntryCredit,
        ), 
        title: CustomTextButton(
          text: register.description!,
          fixedSizeText: true,
          alignment: Alignment.centerLeft,
          onPressed: ()async  {   
            final result = await AccountRegisterDialog(context,register,null,null);           
            if(result == 'update'){
              controller.update();
            }
          },
          foregroundColor: theme.foregroundEntryCredit,
        ),
        trailing: const SizedBox(width: 20,),
      )
      : ListTile(
        leading:  Icon(
          theme.debtIcon,
          color: theme.foregroundEntryDebt,
        ), 
        title: CustomTextButton(
          text: register.description!,
          fixedSizeText: true,
          alignment: Alignment.centerLeft,
          onPressed: ()async  {   
            String result = await AccountRegisterDialog(context,register,null,null);
            if(result == 'update'){
              controller.update();
            }
          },
          foregroundColor: theme.foregroundEntryDebt,
        ),
        trailing: const SizedBox(width: 20,),
      )
    );
  }
  
  void onReorderListItem (int oldItemIndex,int oldListIndex,int newItemIndex,int newListIndex) async {
      final oldListItems = lists[oldListIndex].children;
      final newListItems = lists[newListIndex].children;

      final movedItem = oldListItems.removeAt(oldItemIndex);
      newListItems.insert(newItemIndex, movedItem);  

      if(oldListIndex==newListIndex){
        controller.allLists[oldListIndex].replace(oldItemIndex,newItemIndex);      
      }else{
        controller.allLists[newListIndex].add(controller.allLists[oldListIndex].accounts[oldItemIndex],newItemIndex);
        controller.allLists[oldListIndex].remove(oldItemIndex);        
      }

      controller.update();   
  }

  void onReorderList(int oldListIndex,int newListIndex) {    
      final movedList = lists.removeAt(oldListIndex);
      lists.insert(newListIndex, movedList);

      controller.allLists[oldListIndex].group.sequence = newListIndex;
      AccountGroupConnect().update(controller.allLists[oldListIndex].group);

      if(oldListIndex<=newListIndex){
        for(int i=newListIndex;i>oldListIndex;i--){
          controller.allLists[i].group.sequence = i-1;   
          AccountGroupConnect().update(controller.allLists[i].group);       
        }        
      }else{
        for(int i=newListIndex;i<oldListIndex;i++){
          controller.allLists[i].group.sequence = i+1;
          AccountGroupConnect().update(controller.allLists[i].group);
        }
      }

    controller.update();
  }

}

  