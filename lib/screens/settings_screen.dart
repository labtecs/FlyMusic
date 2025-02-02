import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flymusic/music/finder/shared.dart';
import 'package:flymusic/screens/impress_screen.dart';
import 'package:flymusic/util/shared_preferences_settings.dart';
import 'package:flymusic/util/shared_prefrences_util.dart';
import 'package:flymusic/util/themes.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CustomSettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<CustomSettingsScreen> {
  Directory externalDirectory;

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
        title: tr("app_settings", context: context),
        children: [
          getFolders(),
          SettingsTileGroup(title: tr("general", context: context), children: [
            SimpleSettingsTile(
                icon: Icon(Icons.info_outline),
                title: tr("impress", context: context),
                screen: ImpressScreen()),
            RadioPickerSettingsTile(
                settingKey: PrefKey.LANGUAGE.index.toString(),
                title: tr("language", context: context),
                values: {
                  '1': tr("english", context: context),
                  '2': tr("german", context: context),
                },
                defaultKey: "1",
                onValChange: (val) => setLanguage(val),
                onCancel: () async {
                  //reset
                  setLanguage(await SharedPreferencesUtil.instance
                      .getString(PrefKey.LANGUAGE));
                },
                onConfirm: (val) => SharedPreferencesUtil.instance
                    .setString(PrefKey.LANGUAGE, val)),
            RadioPickerSettingsTile(
                settingKey: PrefKey.THEME.toString(),
                title: tr("theme", context: context),
                values: {
                  '1': tr("auto_theme", context: context),
                  '2': tr("light_theme", context: context),
                  '3': tr("dark_theme", context: context),
                },
                defaultKey: '1',
                onValChange: (val) => setTheme(val),
                onCancel: () async {
                  //reset
                  setTheme(await SharedPreferencesUtil.instance
                      .getString(PrefKey.THEME));
                },
                onConfirm: (val) => {
                      SharedPreferencesUtil.instance
                          .setString(PrefKey.THEME, val)
                    }),
          ]),
          SettingsTileGroup(title: tr("queue", context: context), children: [
            RadioPickerSettingsTile(
                settingKey: PrefKey.QUEUE_CLEAR_OPTION.index.toString(),
                title: tr("queue_behavior_playlist_change", context: context),
                values: {
                  '1': tr("queue_never_clear", context: context),
                  '2': tr("queue_clear", context: context)
                },
                defaultKey: '1'),
            SwitchSettingsTile(
                settingKey: PrefKey.QUEUE_WARNING_ON_CLEAR.index.toString(),
                title: tr("queue_question_clear", context: context),
                subtitle: tr("queue_not_empty", context: context),
                defaultValue: true),
            RadioPickerSettingsTile(
                settingKey: PrefKey.QUEUE_INSERT_OPTION.index.toString(),
                title: tr("queue_insert", context: context),
                values: {
                  '1': tr("queue_insert_top", context: context),
                  '2': tr("queue_insert_bottom", context: context)
                },
                defaultKey: '2'),
          ]),
          SettingsTileGroup(
            title: tr("songs", context: context),
            children: [
              RadioPickerSettingsTile(
                  settingKey: PrefKey.SONG_SHORT_PRESS.index.toString(),
                  title: tr("short_press", context: context),
                  values: {
                    '1': tr("song_play_change_playlist", context: context),
                    '2': tr("song_play_not_change_playlist", context: context),
                    '3': tr("song_queue_insert", context: context),
                    '-1': tr("no_action", context: context)
                  },
                  defaultKey: '1'),
              RadioPickerSettingsTile(
                  settingKey: PrefKey.SONG_LONG_PRESS.index.toString(),
                  title: tr("long_press", context: context),
                  values: {
                    '1': tr("song_play_change_playlist", context: context),
                    '2': tr("song_play_not_change_playlist", context: context),
                    '3': tr("song_queue_insert", context: context),
                    '-1': tr("no_action", context: context)
                  },
                  defaultKey: '2'),
              RadioPickerSettingsTile(
                  settingKey: PrefKey.SONG_ACTION_BUTTON.index.toString(),
                  title: tr("action_button", context: context),
                  values: {
                    '1': tr("song_play_change_playlist", context: context),
                    '2': tr("song_play_not_change_playlist", context: context),
                    '3': tr("song_queue_insert", context: context),
                    '-1': tr("no_action", context: context)
                  },
                  defaultKey: '3'),
            ],
          )
        ]);
  }

  setTheme(String index) {
    if (index == '1') {
      Provider.of<ThemeModel>(context, listen: false).setTheme(ThemeType.Auto);
    } else if (index == '2') {
      Provider.of<ThemeModel>(context, listen: false).setTheme(ThemeType.Light);
    } else if (index == '3') {
      Provider.of<ThemeModel>(context, listen: false).setTheme(ThemeType.Dark);
    }
  }

  setLanguage(String index) {
    EasyLocalization.of(context).locale =
        EasyLocalization.of(context).supportedLocales[int.parse(index) - 1];
  }

  Future<void> chooseFolder() async {
    /* if (Platform.isWindows) {
      var folder = Directory("C:/Users/kilia/Music");
      readMusicFolder(folder.path);
      await SharedPreferencesUtil.getList(PrefKey.PATH_LIST).then((list) async {
        list.add(folder.toString());
        await SharedPreferencesUtil.setList(PrefKey.PATH_LIST, list);
      });
      setState(() {});
    } else {*/
    if (await Permission.storage.request().isGranted) {
      //  await getStorage();

      Navigator.of(context).push<FolderPickerPage>(
          MaterialPageRoute(builder: (BuildContext context) {
        return FolderPickerPage(
            rootDirectory: Directory("/storage/emulated/0/"),

            /// a [Directory] object
            action: (BuildContext context, Directory folder) async {
              Navigator.of(context).pop();

              readMusicFolder(folder.path);

              await SharedPreferencesUtil.getList(PrefKey.PATH_LIST)
                  .then((list) async {
                list.add(folder.toString());
                await SharedPreferencesUtil.setList(PrefKey.PATH_LIST, list);
              });

              setState(() {});

              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(tr('music_import', context: context)),
                    content: Text(tr('music_import_info', context: context)),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(tr('ok', context: context)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            });
      }));
    }
  }

  Widget getFolders() {
    return FutureBuilder(
        future: SharedPreferencesUtil.getList(PrefKey.PATH_LIST),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          return ExpansionSettingsTile(
              initiallyExpanded: true,
              icon: Icon(Icons.library_music),
              title: tr("music_folder", context: context),
              children: getList(snapshot));
        });
  }

  List<Widget> getList(AsyncSnapshot<List<String>> snapshot) {
    if (snapshot.hasData && snapshot.data != null) {
      var list = List<Widget>();
      for (var item in snapshot.data) {
        list.add(SimpleSettingsTile(
          title: item,
        ));
      }
      list.add(SimpleSettingsTile(
        icon: Icon(Icons.create_new_folder),
        title: tr("add_music_folder", context: context),
        onTap: () => chooseFolder(),
      ));
      return list;
    } else {
      return [
        SimpleSettingsTile(
          icon: Icon(Icons.create_new_folder),
          title: tr("add_music_folder", context: context),
          onTap: () => chooseFolder(),
        )
      ];
    }
  }
}
