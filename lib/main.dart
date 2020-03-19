import 'package:flutter/material.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/screens/main_screen.dart';
import 'package:flymusic/util/shared_prefrences_util.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  MyApp.db = db;

  if (await SharedPreferencesUtil.instance.getBool(PrefKey.FIRST_APP_START) !=
      false) {
    //first start: "Warteschlange" und "Alle lieder" playlist in Playlists
    await db.playlistDao.insert(Playlist(id: 0, name: "Alle Lieder"));
    await db.playlistDao.insert(Playlist(id: 1, name: "Warteschlange"));

    //init settings
    await SharedPreferencesUtil.instance
        .setString(PrefKey.SONG_SHORT_PRESS, '1');
    await SharedPreferencesUtil.instance
        .setString(PrefKey.SONG_LONG_PRESS, '2');
    await SharedPreferencesUtil.instance
        .setString(PrefKey.SONG_ACTION_BUTTON, '3');
    await SharedPreferencesUtil.instance
        .setString(PrefKey.QUEUE_CLEAR_OPTION, '1');
    await SharedPreferencesUtil.instance
        .setBool(PrefKey.QUEUE_WARNING_ON_CLEAR, true);
    await SharedPreferencesUtil.instance
        .setString(PrefKey.QUEUE_INSERT_OPTION, '2');

    //TODO show start screen
    await SharedPreferencesUtil.instance
        .setBool(PrefKey.FIRST_APP_START, false);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static AppDatabase db;

  MyApp();

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
          Provider(create: (_) => db.playlistDao),
          Provider(create: (_) => db.playlistItemDao),
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
