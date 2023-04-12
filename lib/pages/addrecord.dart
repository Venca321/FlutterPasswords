// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:passwords/database.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class AddRecord extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    final _formKey0 = GlobalKey<FormState>();
    final _formKey1 = GlobalKey<FormState>();
    final _formKey2 = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 72),
              const Text("Přidání záznamu"),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey0,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Název služby',
                    ),
                    validator: (value){
                      value ??= "";
                      return value.isEmpty ? 'Vyplňte prosím toto pole' : null;
                    },
                    onChanged: (value) {
                      appState.name = value;
                    }
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey1,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Uživatelské jméno',
                    ),
                    validator: (value){
                      value ??= "";
                      return value.isEmpty ? 'Vyplňte prosím toto pole' : null;
                    },
                    onChanged: (value) {
                      appState.username = value;
                    }
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey2,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Heslo',
                    ),
                    validator: (value){
                      value ??= "";
                      return value.isEmpty ? 'Vyplňte prosím toto pole' : null;
                    },
                    onChanged: (value) {
                      appState.password = value;
                    }
                  )
                ),
              ),
              Buttons(appState: appState, formKey0: _formKey0, formKey1: _formKey1, formKey2: _formKey2)
            ]
          ),
        ),
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({
    super.key,
    required this.appState,
    required this.formKey0,
    required this.formKey1,
    required this.formKey2
  });

  final MyAppState appState;
  final formKey0;
  final formKey1;
  final formKey2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
            onPrimary: Colors.white // Background color
          ),
          onPressed: (){
            appState.changePage(0);
          }, 
          child: const Text("Zrušit")
        ),
        SizedBox(width: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            onPrimary: Colors.white // Background color
          ),
          onPressed: (){
            if (formKey0.currentState!.validate() && 
                formKey1.currentState!.validate() && 
                formKey2.currentState!.validate()) {
              addRecord(appState.name, appState.username, appState.password);
              appState.changePage(0);
              appState.name = "";
              appState.username = "";
              appState.password = "";
            }
          }, 
          child: const Text("Potvrdit")
        ),
      ],
    );
  }
}