import 'package:flutter/material.dart';
import 'package:flymusic/screens/main_screen.dart';

import 'database/app_database.dart';

Future<void> main() async {
  final database = await $FloorAppDatabase
      .databaseBuilder('fapp_database.db')
      .build();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fly Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartScreen(),
    );
  }
}