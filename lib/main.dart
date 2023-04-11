// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:passwords/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'package:passwords/pages/home.dart';
import 'package:passwords/pages/auth.dart';

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

  void checkPin(pin, enteredPin){
    if (pin == enteredPin){
      authed = true;
      notifyListeners();
    }
  }

  var pin = null;
  void setPin(newPin){
    pin = newPin;
    notifyListeners();
  }

  var biometrics = null;
  void setBiometrics(newBiometrics){
    biometrics = newBiometrics;
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
      return AuthPage();
    }
  }
}