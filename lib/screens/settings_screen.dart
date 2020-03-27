import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flymusic/music/finder/shared.dart';
import 'package:flymusic/screens/impress_screen.dart';
import 'package:flymusic/util/shared_preferences_settings.dart';
import 'package:flymusic/util/shared_prefrences_util.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomSettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<CustomSettingsScreen> {
  Directory externalDirectory;



  @override
  Widget build(BuildContext context) {
    return SettingsScreen(title: "Application Settings", children: [
      getFolders(),
      SettingsTileGroup(title: 'Allgemein', children: [
        SimpleSettingsTile(
            icon: Icon(Icons.info_outline),
            title: 'Impressum',
            screen: ImpressScreen()
        ),
        RadioSettingsTile(
          settingKey: PrefKey.THEME_OPTION.toString(),
          title: "Theme",
          values: {'1': 'Light Theme', '2': 'Dark Theme'},
          defaultKey: '1',
        ),
      ]),
      SettingsTileGroup(title: 'Warteliste', children: [
        RadioPickerSettingsTile(
            settingKey: PrefKey.QUEUE_CLEAR_OPTION.index.toString(),
            title: 'Verhalten bei wechsel zu einer anderen Playlist',
            values: {'1': 'Warteliste nie verwerfen', '2': 'Warteliste leeren'},
            defaultKey: '1'),
        SwitchSettingsTile(
            settingKey: PrefKey.QUEUE_WARNING_ON_CLEAR.index.toString(),
            title: 'Nachfragen bevor die Warteliste geleert wird',
            subtitle: 'Falls die Warteliste nicht leer ist',
            defaultValue: true),
        RadioPickerSettingsTile(
            settingKey: PrefKey.QUEUE_INSERT_OPTION.index.toString(),
            title: 'Einfügen in die Warteliste',
            values: {'1': 'Oben (Als nächtes Lied)', '2': 'Unten (Am Ende)'},
            defaultKey: '2'),
      ]),
      SettingsTileGroup(
        title: 'Lieder',
        children: [
          RadioPickerSettingsTile(
              settingKey: PrefKey.SONG_SHORT_PRESS.index.toString(),
              title: 'Kurz drücken',
              values: {
                '1': 'Sofort Abspielen und zur Playlist wechseln',
                '2': 'Abspielen ohne Wechsel',
                '3': 'An die Wiedergabeliste hinzufügen',
                '-1': 'Keine Aktion'
              },
              defaultKey: '1'),
          RadioPickerSettingsTile(
              settingKey: PrefKey.SONG_LONG_PRESS.index.toString(),
              title: 'Lange drücken',
              values: {
                '1': 'Sofort Abspielen und Playlist wechseln',
                '2': 'Abspielen ohne Wechsel',
                '3': 'An die Wiedergabeliste hinzufügen',
                '-1': 'Keine Aktion'
              },
              defaultKey: '2'),
          RadioPickerSettingsTile(
              settingKey: PrefKey.SONG_ACTION_BUTTON.index.toString(),
              title: 'Aktions Button',
              values: {
                '1': 'Sofort Abspielen und zur Playlist wechseln',
                '2': 'Abspielen ohne Wechsel',
                '3': 'An die Wiedergabeliste hinzufügen',
                '-1': 'Keine Aktion'
              },
              defaultKey: '3'),
        ],
      )
    ]);
  }

  Future<void> chooseFolder() async {
    if (Platform.isWindows) {
      var folder = Directory("C:/Users/kilia/Music");
      readMusicFolder(folder.path);
      await SharedPreferencesUtil.getList(PrefKey.PATH_LIST).then((list) async {
        list.add(folder.toString());
        await SharedPreferencesUtil.setList(PrefKey.PATH_LIST, list);
      });
      setState(() {});
    } else {
      var result = await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      if (result[PermissionGroup.storage] == PermissionStatus.granted) {
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
                      title: Text('Import von Musik'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('Das Importieren der Musik'),
                            Text('dauert einen Moment')
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Ok'),
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
  }

  Widget getFolders() {
    return FutureBuilder(
        future: SharedPreferencesUtil.getList(PrefKey.PATH_LIST),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          return ExpansionSettingsTile(
              initiallyExpanded: true,
              icon: Icon(Icons.library_music),
              title: "Musik Ordner",
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
        title: 'Musikordner Hinzufügen',
        onTap: () => chooseFolder(),
      ));
      return list;
    } else {
      return [
        SimpleSettingsTile(
          icon: Icon(Icons.create_new_folder),
          title: 'Musikordner Hinzufügen',
          onTap: () => chooseFolder(),
        )
      ];
    }
  }


}
