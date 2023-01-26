
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:firebase_write/database.dart/connection/accountConnect.dart';
import 'package:firebase_write/database.dart/connection/accountGroupConnect.dart';
import 'package:firebase_write/database.dart/register/accountGroupRegister.dart';
import 'package:firebase_write/database.dart/register/accountRegister.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_write/settings/theme.dart';


class MyApp extends StatelessWidget {
  static const String title = 'Drag & Drop ListView';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.red),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  late List<DragAndDropList> lists;
  bool _isLoading = true;

  @override
  initState() {    
    super.initState();
    _getAccount();        
  }

  _getAccount() async {
    List<DraggableList> _allLists = <DraggableList>[];

    List<AccountGroupRegister>? group = await AccountGroupConnect().getData();
    List<AccountRegister>? account = await AccountConnect().getData();

    for(int i=0;i<group!.length;i++){
      List<DraggableListItem> _items = <DraggableListItem>[];
      for(int j=0;j<account!.length;j++){
        if(group[i].id==account[j].idGroup){
          _items.add(DraggableListItem(
            title: account[j].description.toString(),
            credit: account[j].credit!,
          ));
        }
      }
      _allLists.add(DraggableList(
        header: group[i].description.toString(), 
        items: _items
      ));
    }

    lists = _allLists.map(buildList).toList();
    setIsloading(false);
  } 

  void setIsloading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  } 
  
  @override
  Widget build(BuildContext context) {
    final backgroundColor = Color.fromARGB(255, 243, 242, 248);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(MyApp.title),
        centerTitle: true,
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : DragAndDropLists(
            listPadding: const EdgeInsets.all(16),
            listInnerDecoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(10),
            ),
            children: lists,
            itemDivider: Divider(thickness: 2, height: 2, color: backgroundColor),
            itemDecorationWhileDragging: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            listDragHandle: buildDragHandle(isList: true),
            itemDragHandle: buildDragHandle(),
            onItemReorder: onReorderListItem,
            onListReorder: onReorderList,
          ),
    );
  }

  DragHandle buildDragHandle({bool isList = false}) {
    final verticalAlignment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;
    final color = isList ? Colors.blueGrey : Colors.black26;

    return DragHandle(
      verticalAlignment: verticalAlignment,
      child: Container(
        padding: const EdgeInsets.only(right: 10),
        child: FaIcon(
          FontAwesomeIcons.upDown,
          color: color),
      ),
    );
  }

  DragAndDropList buildList(DraggableList list) => DragAndDropList(
        header: Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            list.header,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
          ),
        ),
        children: list.items
            .map((item) => DragAndDropItem(
                  child: item.credit ?
                    ListTile(
                      leading:  Icon(
                        Icons.attach_money,
                        color: theme.foregroundEntryCredit,
                      ), 
                      title: Text(
                        item.title,
                        style: TextStyle(
                          color: theme.foregroundEntryCredit
                        ),
                      ),
                    )
                    :                 
                    ListTile(
                      leading: Icon(
                        Icons.money_off,
                        color: theme.foregroundEntryDebt,
                      ), 
                      title: Text(
                        item.title,
                        style: TextStyle(
                          color: theme.foregroundEntryDebt
                        ),
                      ),                    
                    ),
                ))
            .toList(),
      );

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

class DraggableList {
  final String header;
  final List<DraggableListItem> items;

  const DraggableList({
    required this.header,
    required this.items,
  });
}

class DraggableListItem {
  final String title;
  final bool credit;

  const DraggableListItem({
    required this.title,
    required this.credit
  });
}

