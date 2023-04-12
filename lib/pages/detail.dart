// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class DetailPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 16),
              NavButtons(appState: appState),
              const Text("Podrobné informace", style: TextStyle(fontSize: 28)),
              Text("Název služby: ${appState.detailName}", style: TextStyle(fontSize: 18)),
              Text("Uživatelské jméno: ${appState.detailUsername}", style: TextStyle(fontSize: 18)),
              PasswordRow(appState: appState)
            ]
          ),
        ),
      )
    );
  }
}

class NavButtons extends StatelessWidget {
  const NavButtons({
    super.key,
    required this.appState,
  });

  final MyAppState appState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 12, 50, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: (){
              appState.detailName = "";
              appState.detailUsername = "";
              appState.detailPassword = "";
              appState.changePage(0);
            }, 
            child: const Text("Zpět")
          ),
          InkWell(
            onTap: (){
              print("Copy");
            },
            child: Icon(Icons.copy, color: Colors.black),
          ),
          InkWell(
            onTap: (){
              print("Remove");
            },
            child: Icon(Icons.delete, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class PasswordRow extends StatelessWidget {
  const PasswordRow({
    super.key,
    required this.appState
  });

  final appState;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Heslo: ", style: TextStyle(fontSize: 18)),
        Text("${appState.detailPassword}", style: TextStyle(fontSize: 18)),
        ElevatedButton(
          onPressed: (){

          }, 
          child: Icon(Icons.remove_red_eye)
        )
      ],
    );
  }
}