// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../database.dart';
import '../main.dart';

class AuthPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    getUser().then((value) => {
      if (value != null){
        appState.setPin("${value['pin']}"),
        appState.setBiometrics(value["biometrics"])
      }
      else{
        appState.setPin(null)
      }
    });

    if(appState.pin == null){
      return RegisterPage();
    }
    else{
      return LoginPage();
    }
  }
}

class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    if (appState.biometrics && appState.askBiometrics){
      appState.askBiometrics = false;
      appState.authenticate();
    }
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Přihlášení", style: TextStyle(fontSize: 30)),
                PinInput(),
                if (appState.biometrics)
                  ElevatedButton(
                    onPressed: (){
                      appState.authenticate();
                    }, 
                    child: const Text("Použít biometrické ověření", style: TextStyle(fontSize: 20))
                  ),
                SizedBox(height: 150)
              ],
            ),
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
        padding: const EdgeInsets.all(20.0),
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
            appState.checkPin(appState.pin, value);
          },
        )
      ),
    );
  }
}

class RegisterPage extends StatefulWidget{
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();

    var icon;
    if (appState.biometrics){
      icon = Icons.check_box;
    }
    else{
      icon = Icons.check_box_outline_blank;
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 60),
              const Text("Registrace", style: TextStyle(fontSize: 28)),
              SizedBox(height: 20),
              RegisterPin(),
              ElevatedButton.icon(
                onPressed: (){
                  if (appState.biometrics){
                    appState.biometrics = false;
                  }
                  else{
                    appState.biometrics = true;
                  }
                  setState(() {});
                }, 
                icon: Icon(icon), 
                label: const Text("Povolit biometrické ověřování")
              ),
              SizedBox(height: 22),
              ElevatedButton(
                onPressed: (){
                  if (appState.registerPin1 == appState.registerPin2){
                    userRegister(appState.registerPin1, appState.biometrics);
                  }
                }, 
                child: const Text("Registrovat")
              ),
            ],
          ),
        )
      ),
    );
  }
}

class RegisterPin extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    return Column(
      children: [
        Form(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
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
                appState.registerPin1 = value;
              },
            )
          ),
        ),
        Form(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
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
                appState.registerPin2 = value;
              },
            )
          ),
        ),
      ],
    );
  }
}