import 'package:firebase_write/custom/widgets/customCreditDebt.dart';
import 'package:firebase_write/custom/widgets/customCurrencyTextField.dart';
import 'package:firebase_write/custom/widgets/customDateTextField.dart';
import 'package:firebase_write/custom/widgets/customDropDown.dart';
import 'package:firebase_write/custom/widgets/customFloatingButton.dart';
import 'package:firebase_write/custom/widgets/customTextField.dart';
import 'package:firebase_write/models/financial_entry/financial_entry_register.dart';
import 'package:firebase_write/page/financial_register/financial_entry_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FinancialEntryPage extends StatefulWidget {
  const FinancialEntryPage({Key? key, this.register}) : super(key: key);

  final FinancialEntryRegister? register;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FinancialEntryPage> {
  late FinancialEntryController controller;  

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller = Provider.of(context);
    controller.setData(widget.register);

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
        centerTitle: true,
        title: const Text("LANÇAMENTO FINANCEIRO"),
      ),
      body: controller.state == FinancialEntryState.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: CustomTextField(
                              controller: controller.tdcId,
                              icon: Icons.article_rounded,
                              enabled: false,
                              label: "Id",
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          CustomCreditDebt(
                            isCredit: controller.isCredit, 
                            onToggle: (value) {
                              controller.changeType(value);                     
                            },
                          ),
                        ]),                       
                    CustomDropDown(
                      list: controller.typeList,
                      selected: controller.typeValue,
                      icon: Icons.account_balance,
                      add: () {
                      },                    
                      change: (value) {
                        controller.typeValue=value;             
                      },
                    ),
                    CustomTextField(
                      controller: controller.tdcDescription,
                      label: 'Descrição',
                    ),
                    CustomDateTextField(
                      controller: controller.tdcDate,
                    ),
                    CustomCurrencytextField(
                      controller: controller.tdcValue, 
                      errorText: controller.errorValue,
                    ),
                    _buttonRow(),
                  ]),
            ),
    );
  }

  Widget _buttonRow() {
    List<Widget> buttons = <Widget>[];
    
    if (controller.btUpdate) {
      buttons.add(
        CustomFloatingButton(
          onPressed: () {
            controller.update(context);
          },
          icon: Icons.update,
        )      
      );
    }
    if (controller.btDelete) {
      buttons.add(
        CustomFloatingButton(
          onPressed: () {
            controller.delete(context);
          },
          icon: Icons.delete
        )
      );
    }
    if (controller.btInclude) {
      buttons.add(
        CustomFloatingButton(
          onPressed: () {
            controller.save(context);
          },
          icon: Icons.add,
        )
      );
    }
    if (controller.btClear) {
      buttons.add(
        CustomFloatingButton(
          onPressed: () {
            controller.clean();
          },
          icon: Icons.cleaning_services
        )
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }

}
