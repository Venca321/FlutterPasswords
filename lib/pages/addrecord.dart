// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:passwords/database.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class AddRecord extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 24),
              const Text("Přidání záznamu"),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Název služby',
                    ),
                    validator: (value){
                      value ??= "";
                      return value.length < 2 ? 'Name must be greater than two characters' : "";
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
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Uživatelské jméno',
                    ),
                    validator: (value){
                      value ??= "";
                      return value.length < 2 ? 'Name must be greater than two characters' : "";
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
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Heslo',
                    ),
                    validator: (value){
                      value ??= "";
                      return value.length < 2 ? 'Name must be greater than two characters' : "";
                    },
                    onChanged: (value) {
                      appState.password = value;
                    }
                  )
                ),
              ),
              Buttons(appState: appState)
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
  });

  final MyAppState appState;

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
            appState.changePage();
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
            addRecord(appState.name, appState.username, appState.password);
            appState.changePage();
            appState.name = "";
            appState.username = "";
            appState.password = "";
          }, 
          child: const Text("Potvrdit")
        ),
      ],
    );
  }
}