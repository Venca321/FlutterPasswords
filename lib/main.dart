import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter password manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: 
        const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
      (bool isSupported) => setState(() {
        _supportState = isSupported;
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_supportState)
              const Text("Supported")
            else
              const Text("Not supported"),

            const Divider(height: 100),

            ElevatedButton(
              onPressed: _authenticate, 
              child: const Text("Authenticate")
              )
          ],
        ),
      ),
    );
  }

  Future<bool> _authenticate() async {
    try{
      bool authenticated = await auth.authenticate(
        localizedReason: "Přihlášení",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false
        )
      );
      return authenticated;
    }on PlatformException catch(e){
      return false;
    }
  }
}
