// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

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

  var pin = {};

  void enter_pin(pin_value, location) async {
    pin[location] = pin_value;
    print(pin);
    notifyListeners();
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 48,
              width: 44,
              child: TextFormField(
                onSaved: (newValue) {
                  appState.enter_pin(newValue, 0);
                },
                onChanged: (value) {
                  if (value.length == 1){
                    FocusScope.of(context).nextFocus();
                  }
                },
                style: Theme.of(context).textTheme.titleLarge,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            SizedBox(
              height: 48,
              width: 44,
              child: TextFormField(
                onSaved: (newValue) {
                  appState.enter_pin(newValue, 1);
                },
                onChanged: (value) {
                  if (value.length == 1){
                    FocusScope.of(context).nextFocus();
                  }
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            SizedBox(
              height: 48,
              width: 44,
              child: TextFormField(
                onSaved: (newValue) {
                  appState.enter_pin(newValue, 2);
                },
                onChanged: (value) {
                  if (value.length == 1){
                    FocusScope.of(context).nextFocus();
                  }
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            SizedBox(
              height: 48,
              width: 44,
              child: TextFormField(
                onSaved: (newValue) {
                  appState.enter_pin(newValue, 3);
                },
                onChanged: (value) {
                  if (value.length == 1){
                    FocusScope.of(context).nextFocus();
                  }
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            SizedBox(
              height: 48,
              width: 44,
              child: TextFormField(
                onSaved: (newValue) {
                  appState.enter_pin(newValue, 4);
                },
                onChanged: (value) {
                  if (value.length == 1){
                    FocusScope.of(context).nextFocus();
                  }
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            SizedBox(
              height: 48,
              width: 44,
              child: TextFormField(
                onSaved: (newValue) {
                  appState.enter_pin(newValue, 5);
                },
                onChanged: (value) {
                  if (value.length == 1){
                    FocusScope.of(context).nextFocus();
                  }
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
          ]
        ),
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