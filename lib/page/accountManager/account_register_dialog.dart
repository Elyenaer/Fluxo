
import 'package:firebase_write/models/account/accountConnect.dart';
import 'package:flutter/material.dart';
import 'package:firebase_write/help/message.dart';
import '../../custom/widgets/customCreditDebt.dart';
import '../../custom/widgets/customTextField.dart';
import '../../models/account/accountRegister.dart';

// ignore: non_constant_identifier_names
Future<String> AccountRegisterDialog(
  BuildContext context,
  AccountRegister? account,
  int? idGroup,
  int? sequence) async { 

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