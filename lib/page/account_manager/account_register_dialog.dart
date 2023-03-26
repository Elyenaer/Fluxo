
import 'package:firebase_write/page/account_manager/account_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_write/help/message.dart';
import '../../custom/widgets/customCreditDebt.dart';
import '../../custom/widgets/customTextField.dart';
import '../../models/account/account_register.dart';

// ignore: non_constant_identifier_names
Future<String> AccountRegisterDialog(
  BuildContext context,
  AccountRegister? account,
  int? idGroup,
  int? sequence
) async { 

  AccountRegisterController _controller = AccountRegisterController(account,idGroup,sequence);

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

  // ignore: unnecessary_null_comparison
  if(account!=null){

    buttons.add(FloatingActionButton(
      child: const Icon(
        Icons.delete,
      ),
      onPressed: () async { 
        if(await _controller.delete()){
          if(await message.confirm(context,'CONFIRME EXCLUSÃO',
          'VOCÊ TEM CERTEZA QUE DESEJA EXCLUIR ESSA CONTA?')){
            _controller.result = 'update';
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
        if(await _controller.update()){
          Navigator.of(context).pop('update');
          message.simple(context,"","CONTA ATUALIZADA COM SUCESSO!");
        }
      },
      )
    );

  }else{
    buttons.add(FloatingActionButton(
      child: const Icon(
        Icons.add,
      ),
      onPressed: () async { 
        if(await _controller.save()){
          Navigator.of(context).pop('update');
          message.simple(context,"","CONTA CADASTRADA COM SUCESSO!");
        }
      },
      )
    );
  }
  
  Widget build = Center(
    child: Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: CustomCreditDebt(
                isCredit: _controller.isCredit, 
                onToggle: (value) {
                  _controller.isCredit = value;              
                }
              )  
            ),                    
          ],
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: 'Descrição',
          controller: _controller.tecDescription
        )
      ],
    )
  );

  AlertDialog m = AlertDialog(
    title: const Center(
      child: Text('CADASTRO DE CONTAS'),
    ),
    content: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 150.0,
          minWidth: 150.0, 
        ),
        child: build,
      ),
    ),
    actionsAlignment: MainAxisAlignment.center,
    actions: buttons,
  );

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return m;
    },
  );

  return _controller.result;
}