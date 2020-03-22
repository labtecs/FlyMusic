import 'package:flutter/material.dart';
import 'package:flymusic/screens/main_screen.dart';
import 'package:flymusic/util/themes.dart';
import 'database/app_database.dart';

AppDatabase database;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();
  //AudioPlayer.logEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fly Music',
      theme: basicTheme(),
      home: StartScreen(),

    );
  }
}