import 'package:flutter/material.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/screens/main_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final db = AppDatabase();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (_) => db.songDao),
          Provider(create: (_) => db.albumDao),
          Provider(create: (_) => db.artistDao),
          Provider(create: (_) => db.artDao),
          Provider(create: (_) => db.queueItemDao),
        ],
        child: MaterialApp(
          title: 'Fly Music',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: StartScreen(),
        ));
  }
}
