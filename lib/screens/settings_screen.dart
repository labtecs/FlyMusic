import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flymusic/music/music_finder.dart';
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
        SwitchSettingsTile(
          icon: Icon(Icons.short_text),
          settingKey: PrefKey.SHOW_POPUP.index.toString(),
          title: 'Popup',
          subtitle: 'Bei Lied/Album Aktionen Popup anzeigen',
          defaultValue: true,
        ),
        SimpleSettingsTile(
          icon: Icon(Icons.info_outline),
          title: 'Impressum',
          screen: ImpressScreen(),
        ),
      ]),
      SettingsTileGroup(
        title: 'Lieder',
        children: [
          RadioPickerSettingsTile(
            settingKey: PrefKey.SONG_SHORT_PRESS.index.toString(),
            title: 'Kurz drücken',
            values: {
              '1': 'Sofort Abspielen',
              '2': 'Als nächstes Abspielen',
              '3': 'An die Wiedergabeliste hinzufügen',
              '-1': 'Keine Aktion'
            },
            defaultKey: '1',
          ),
          RadioPickerSettingsTile(
            settingKey: PrefKey.SONG_LONG_PRESS.index.toString(),
            title: 'Lange drücken',
            values: {
              '1': 'Sofort Abspielen',
              '2': 'Als nächstes Abspielen',
              '3': 'An die Wiedergabeliste hinzufügen',
              '-1': 'Keine Aktion'
            },
            defaultKey: '2',
          ),
          RadioPickerSettingsTile(
            settingKey: PrefKey.SONG_ACTION_BUTTON.index.toString(),
            title: 'Aktions Button',
            values: {
              '1': 'Sofort Abspielen',
              '2': 'Als nächstes Abspielen',
              '3': 'An die Wiedergabeliste hinzufügen',
              '-1': 'Keine Aktion'
            },
            defaultKey: '3',
          ),
        ],
      ),
      SettingsTileGroup(
        title: 'Alben',
        children: [
          RadioPickerSettingsTile(
            settingKey: PrefKey.ALBUM_SHORT_PRESS.index.toString(),
            title: 'Kurz drücken',
            values: {
              '1': 'Sofort Abspielen',
              '2': 'Als nächstes Abspielen',
              '3': 'An die Wiedergabeliste hinzufügen',
              '-1': 'Keine Aktion'
            },
            defaultKey: '1',
          ),
          RadioPickerSettingsTile(
            settingKey: PrefKey.ALBUM_LONG_PRESS.index.toString(),
            title: 'Lange drücken',
            values: {
              '1': 'Sofort Abspielen',
              '2': 'Als nächstes Abspielen',
              '3': 'An die Wiedergabeliste hinzufügen',
              '-1': 'Keine Aktion'
            },
            defaultKey: '2',
          ),
          RadioPickerSettingsTile(
            settingKey: PrefKey.ALBUM_ACTION_BUTTON.index.toString(),
            title: 'Aktions Button',
            values: {
              '1': 'Sofort Abspielen',
              '2': 'Als nächstes Abspielen',
              '3': 'An die Wiedergabeliste hinzufügen',
              '-1': 'Keine Aktion'
            },
            defaultKey: '3',
          ),
        ],
      ),
    ]);
  }

  Future<void> chooseFolder() async {
    var result =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (result[PermissionGroup.storage] == PermissionStatus.granted) {
      //  await getStorage();
      Navigator.of(context).push<FolderPickerPage>(
          MaterialPageRoute(builder: (BuildContext context) {
        return FolderPickerPage(
            rootDirectory: Directory("/storage/emulated/0/"),

            /// a [Directory] object
            action: (BuildContext context, Directory folder) async {
              Navigator.of(context).pop();

              doIsolated(folder);

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
                          Text('dauert einen Moment'),
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
