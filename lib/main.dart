// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        themeMode: ThemeMode.dark,
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
      
      authed = authenticated;
      if (authenticated){
        notifyListeners();
      }
    }on PlatformException catch(e){
      authed = false;
    }
  }

  var pin = null;
  void checkPin(pin, enteredPin){
    if (pin == enteredPin){
      authed = true;
      notifyListeners();
    }
  }

  void setPin(newPin){
    pin = newPin;
    notifyListeners();
  }

  var biometrics = false;
  void setBiometrics(newBiometrics){
    biometrics = newBiometrics;
    notifyListeners();
  }

  var records = [];
  void loadRecords(newRecords){
    records = newRecords;
    notifyListeners();
  }

  var onPage = 0;
  void changePage(page){
    onPage = page;
    notifyListeners();
  }

  var name;
  var username;
  var password;

  var detailName;
  var detailUsername;
  var detailPassword;

  var registerPin1;
  var registerPin2;
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