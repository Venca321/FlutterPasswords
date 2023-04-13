// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'package:passwords/pages/edit.dart';
import 'package:passwords/pages/detail.dart';
import 'package:passwords/database.dart';
import 'package:passwords/pages/addrecord.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    if (appState.onPage == 1)
      return AddRecord();
    else if (appState.onPage == 2)
      return DetailPage();
    else if (appState.onPage == 3)
      return EditPage();
    return HomeWidget();
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    getRecords().then((value) => {
      appState.loadRecords(value)
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                children: [
                  PlusButton(),
                  Text("Vaše záznamy:", style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var record in appState.records)
                        InkWell(
                          onTap: (){
                            appState.detailName = record["name"];
                            appState.detailUsername = record["username"];
                            appState.detailPassword = record["password"];
                            appState.changePage(2);
                          }, 
                          child: MyCard(text: record)
                        )
                    ],
                  )
                )
              )
            ],
          ),
        )
      )
    );
  }
}

class PlusButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 10, 30, 10),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.green),
            )
          )
        ),
        onPressed: (){
          appState.changePage(1);
        },
        child: Icon(
          Icons.add,
          size: 32,
        )
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  const MyCard({
    super.key,
    required this.text,
  });

  final text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 22
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
      child: Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Container(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      text["name"],
                      style: style
                    ),
                    Text(
                      " (${text["username"]})",
                      style: style,
                    )
                  ],
                ),
                TrashButton(text: text, theme: theme)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TrashButton extends StatelessWidget {
  const TrashButton({
    super.key,
    required this.text,
    required this.theme,
  });

  final text;
  final ThemeData theme;

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
                removeRecord(text["name"], text["username"], text["password"]);
                Navigator.pop(context, 'Ok');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: Icon(Icons.delete, color: theme.colorScheme.onPrimary),
    );
  }
}