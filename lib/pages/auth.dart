// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    appState.authenticate();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text("Zadejte pin, nebo použijte biometrické ověření"),
              PinInput(),
              ElevatedButton(
                onPressed: (){
                  appState.authenticate();
                }, 
                child: const Text("Použít biometriku")
              ),
            ],
          ),
        )
      ),
    );
  }
}

class PinInput extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: PinCodeTextField(
          appContext: context, 
          length: 6, 
          onChanged: (value) {}, //Tohle nepotřebuju, ale musí to být definované
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            inactiveColor: Colors.grey
          ),
          onCompleted: (value){
            print("Completed $value");
          },
        )
      ),
    );
  }
}