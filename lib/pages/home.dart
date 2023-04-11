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

    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 50,),
          for (var record in appState.records)
            Text(record["name"], textScaleFactor: 0.4,)
        ],
      )
    );
  }
}

