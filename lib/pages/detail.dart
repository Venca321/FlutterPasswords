// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../database.dart';
import '../main.dart';

class DetailPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 22),
            NavButtons(appState: appState),
            SizedBox(height: 50),
            Column(
              children: [
                const Text("Podrobné informace", style: TextStyle(fontSize: 28)),
                SizedBox(height: 16),
                Text("Název služby: ${appState.detailName}", style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: "${appState.detailUsername}"));
                  },
                  child: Text("Uživatelské jméno: ${appState.detailUsername}", style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 8),
                PasswordRow(appState: appState),
                SizedBox(height: 350),
                const Text("Kliknutím na informaci ji kopírujete do schránky")
              ],
            )
          ]
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
            onTap: () async {
              appState.changePage(3);
            },
            child: Icon(Icons.edit, color: Colors.black),
          ),
          TrashButton(appState: appState),
        ],
      ),
    );
  }
}

class TrashButton extends StatelessWidget {
  const TrashButton({
    super.key,
    required this.appState,
  });

  final appState;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Upozornění'),
          content: const Text('Toto je nevratná operace, určitě chcete záznam smazat?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Zrušit'),
            ),
            TextButton(
              onPressed: (){
                removeRecord(appState.detailName, appState.detailUsername, appState.detailPassword);
                Navigator.pop(context, 'Ok');
                appState.changePage(0);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: Icon(Icons.delete, color: Colors.black),
    );
  }
}

class PasswordRow extends StatefulWidget {
  PasswordRow({
    super.key,
    required this.appState
  });

  final appState;

  @override
  State<PasswordRow> createState() => _PasswordRowState();
}

class _PasswordRowState extends State<PasswordRow> {
  var password = "------------";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            if (password != "------------"){
              await Clipboard.setData(ClipboardData(text: "${widget.appState.detailPassword}"));
            }
          },
          child: Text("Heslo: $password", style: TextStyle(fontSize: 18)),
        ),
        SizedBox(width: 8),
        InkWell(
          onTap: (){
            if (password == "------------"){
              password = widget.appState.detailPassword;
              setState(() {});
            }
            else{
              password = "------------";
              setState(() {});
            }
          }, 
          child: Icon(Icons.remove_red_eye)
        )
      ],
    );
  }
}