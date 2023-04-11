// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:passwords/database.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
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
                  Padding(
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
                        print("Press");
                      },
                      child: Icon(
                        Icons.add,
                        size: 32,
                      )
                    ),
                  ),
                  Text("Vaše záznamy:", style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              SizedBox(height: 20),
              for (var record in appState.records)
                InkWell(
                  onTap: (){
                    print("Pressed");
                  }, 
                  child: MyCard(text: record)
                )
            ],
          ),
        )
      )
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
                Text(
                  text["name"],
                  style: style
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        print("Copy");
                      },
                      child: Icon(Icons.copy, color: theme.colorScheme.onPrimary),
                    ),
                    InkWell(
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Upozornění'),
                          content: const Text('Toto je nevratná operace, určitě chcete záznam smazat?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
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
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DialogExample extends StatelessWidget {
  const DialogExample({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Upozornění'),
          content: const Text('Toto je nevratná operace, určitě chcete záznam smazat?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
}