import 'package:flutter/material.dart';
import 'package:flymusic/screens/start_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fly Music',
      theme: ThemeData(
        primarySwatch: Colors.black,
      ),
      home: StartScreen(),
    );
  }
}

