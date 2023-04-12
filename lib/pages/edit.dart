// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:passwords/database.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class EditPage extends StatelessWidget{
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
              SizedBox(height: 48),
              const Text("Upravit záznam", style: TextStyle(fontSize: 24)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey0,
                  child: TextFormField(
                    initialValue: appState.detailName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Název služby',
                    ),
                    validator: (String? value) {
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
                    initialValue: appState.detailUsername,
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
                    initialValue: appState.detailPassword,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      onPrimary: Colors.white // Background color
                    ),
                    onPressed: (){
                      appState.changePage(2);
                    }, 
                    child: const Text("Zrušit")
                  ),
                  SizedBox(width: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white // Background color
                    ),
                    onPressed: (){
                      if (_formKey0.currentState!.validate() && 
                          _formKey1.currentState!.validate() && 
                          _formKey2.currentState!.validate()) {
                        editRecord(
                          appState.detailName, 
                          appState.detailUsername, 
                          appState.detailPassword, 
                          appState.name, 
                          appState.username, 
                          appState.password
                        );
                        appState.changePage(0);
                      }
                    }, 
                    child: const Text("Potvrdit")
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}