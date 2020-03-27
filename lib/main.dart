import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/plugins/desktop/desktop.dart';
import 'package:flymusic/screens/main_screen.dart';
import 'package:flymusic/util/shared_prefrences_util.dart';
import 'package:flymusic/util/themes.dart';
import 'package:provider/provider.dart';

import 'database/generator/shared.dart';

void main() async {
  setTargetPlatformForDesktop();
  WidgetsFlutterBinding.ensureInitialized();

  MyApp.db = constructDb(logStatements: true);

  if (await SharedPreferencesUtil.instance.getBool(PrefKey.FIRST_APP_START) !=
      false) {
    //first start: "Warteschlange" und "Alle lieder" playlist in Playlists
    await MyApp.db.playlistDao
        .insert(PlaylistsCompanion.insert(name: "Alle Lieder", type: -1));
    await MyApp.db.playlistDao
        .insert(PlaylistsCompanion.insert(name: "Warteschlange", type: -1));

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
    await SharedPreferencesUtil.instance.setString(PrefKey.LANGUAGE, '1');

    //TODO show start screen
    await SharedPreferencesUtil.instance
        .setBool(PrefKey.FIRST_APP_START, false);
  }

  runApp(EasyLocalization(
      child: MyApp(),
      supportedLocales: [Locale('en', 'US'), Locale('de', 'DE')],
      path: 'asset/langs'));
}

class MyApp extends StatelessWidget {
  static AppDatabase db;

  MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SharedPreferencesUtil.instance.getString(PrefKey.LANGUAGE).then((val) =>
        EasyLocalization.of(context).locale =
            EasyLocalization.of(context).supportedLocales[int.parse(val) - 1]);
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
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            EasyLocalization.of(context).delegate,
          ],
          supportedLocales: EasyLocalization.of(context).supportedLocales,
          locale: EasyLocalization.of(context).locale,
          theme: basicTheme(),
          home: StartScreen(),
        ));
  }
}
