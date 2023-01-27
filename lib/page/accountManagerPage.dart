
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:firebase_write/custom/widgets/customCreditDebt.dart';
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
    setIsloading(true);
    List<AccountGroupRegister>? group = await AccountGroupConnect().getData();
    List<AccountRegister>? account = await AccountConnect().getData();

    _allLists.clear();

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
              _getAccount();
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
          group.group.description = await _accountRegister(
            context,null,group.group.id,group.nextSequence);
            setState(() { 
              _getAccount();
            }
          );          
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
          onPressed: ()async  {   
            final result = await _accountRegister(context,register,null,null);
           
            if(result == 'update'){
              setState(() {
                _updateList();
              });
            }
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
          onPressed: ()async  {   
            String result = await _accountRegister(context,register,null,null);
            if(result == 'update'){
              setState(() {
                _updateList();
              });
            }
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





      print("oldItem -> $oldItemIndex \noldList -> $oldListIndex \nnewItem -> $newItemIndex \nnewList -> $newListIndex");




      if(oldListIndex==newListIndex){
        _allLists[oldListIndex].replace(oldItemIndex,newItemIndex);      
      }else{
        _allLists[newListIndex].add(_allLists[oldListIndex].accounts[oldItemIndex]);
        _allLists[oldListIndex].remove(oldItemIndex);

        
      }

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
  int nextSequence = 0;

  _Group({
    required this.group,
    required this.accounts,
  });

  replace(int oldIndex,int newindex){
    AccountConnect connect = AccountConnect();
    accounts[oldIndex].groupSequence = newindex;
    connect.update(accounts[oldIndex]);
    if(oldIndex<newindex){      
      for(int i=newindex;i>oldIndex;i--){
        accounts[i].groupSequence = i-1;
        connect.update(accounts[i]);
      }      
    }else{
      for(int i=newindex;i<oldIndex;i++){
        accounts[i].groupSequence = i+1;
        connect.update(accounts[i]);
      } 
    }        
  }

  remove(int index){
    accounts.remove(accounts[index]);
  }

  add(AccountRegister register){
    register.idGroup = group.id;
    register.groupSequence = accounts.length;
    accounts.add(register);
  }

  sort(){
    // ignore: prefer_function_declarations_over_variables
    Comparator<AccountRegister> sortById = (a, b) => a.groupSequence!.compareTo(b.groupSequence!);
    accounts.sort(sortById);
    nextSequence = accounts.length;
  }

}

Future<String> _accountRegister(BuildContext context,AccountRegister? account,int? idGroup,int? sequence) async { 

  String result = '';
  AccountConnect connect = AccountConnect();
  AccountRegister register;
  String id;
  String description;
  if(account!=null){
    register = account;
    id = account.id.toString();
    description = account.description.toString();    
  }else{
    register = AccountRegister();
    id = await connect.getNextId();
    description = '';
  }  

  TextEditingController _tecId = TextEditingController(text: id);
  TextEditingController _tecDescription = TextEditingController(text: description);
  bool _isCredit = true;
  
  List<Widget> buttons = <Widget>[];
  buttons.add(FloatingActionButton(
    child: const Icon(
      Icons.arrow_back,
    ),
    onPressed: () { 
      Navigator.of(context).pop();
    },
    ),
  );
  if(account!=null){
    buttons.add(FloatingActionButton(
      child: const Icon(
        Icons.delete,
      ),
      onPressed: () async { 
        if(await AccountConnect().delete(register)){
          if(await message.confirm(context,'CONFIRME EXCLUSÃO',
          'VOCÊ TEM CERTEZA QUE DESEJA EXCLUIR ESSA CONTA?')){
            result = 'update';
            Navigator.of(context).pop('update');
            message.simple(context,'','CONTA EXCLUÍDA COM SUCESSO!');
          }else{
            return;
          }          
        }else{
          message.simple(context, 'NEGADO!',
          'EXISTEM REGISTROS FINANCEIROS NA CONTA'
          ' QUE VOCÊ ESTÁ TENTANDO EXCLUIR');
        }        
      },
      )
    );
    buttons.add(FloatingActionButton(
      child: const Icon(
        Icons.update,
      ),
      onPressed: () async { 
        result = 'update';

        register.description = _tecDescription.text;
        register.credit = _isCredit;
        await AccountConnect().update(register);
        
        Navigator.of(context).pop('update');
        message.simple(context,"","CONTA ATUALIZADA COM SUCESSO!");
      },
      )
    );
  }else{
    buttons.add(FloatingActionButton(
      child: const Icon(
        Icons.add,
      ),
      onPressed: () async { 
        result = 'update';

        register.id = int.parse(_tecId.text);
        register.description = _tecDescription.text;
        register.idGroup = idGroup;
        register.credit = _isCredit;
        register.groupSequence = sequence;
        await AccountConnect().setData(register);
        
        Navigator.of(context).pop('update');
        message.simple(context,"","CONTA CADASTRADA COM SUCESSO!");
      },
      )
    );
  }
  
  Widget build = Center(
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                icon: Icons.article_rounded,
                label: 'ID',
                enabled: false,
                controller: _tecId
              ),
            ),
            const SizedBox(width: 20),
            CustomCreditDebt(
              isCredit: _isCredit, 
              onToggle: (value) {
                _isCredit = value;              
              }
            )          
          ],
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'Descrição',
          controller: _tecDescription
        )
      ],
    )
  );

  AlertDialog m = AlertDialog(
    title: const Center(
      child: Text('CADASTRO DE CONTAS'),
    ),
    content: build,
    actionsAlignment: MainAxisAlignment.center,
    actions: buttons,
  );

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return m;
    },
  );

  return result;
}