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
              Text("Vaše záznamy:", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 20),
              for (var record in appState.records)
                InkWell(
                  onTap: (){
                    print("Pressed");
                  }, 
                  child: MyCard(text: record["name"])
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

  final String text;

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
            child: Text(
              text,
              style: style
            ),
          ),
        ),
      ),
    );
  }
}
