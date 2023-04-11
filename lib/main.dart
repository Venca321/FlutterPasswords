// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Password manager',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const MainPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var authed = false;

  void authenticate() async {
    final LocalAuthentication auth = LocalAuthentication();

    try{
      bool authenticated = await auth.authenticate(
        localizedReason: "Přihlášení",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true
        )
      );
      if (authenticated){
        authed = authenticated;
        notifyListeners();
      }
    }on PlatformException catch(e){
      authed = false;
    }
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var authed = appState.authed;

    if (authed){
      return HomePage();
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

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: const Text("HomePage")
      )
    );
  }
}