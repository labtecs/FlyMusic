import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flymusic/music/music_finder.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';

class CustomSettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<CustomSettingsScreen> {
  String folderLocation = "noch nichts importiert";

  Directory externalDirectory;
  bool _queueFirst = true;

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(title: "Application Settings", children: [
      CheckboxSettingsTile(
        settingKey: 'Music Import',
        title: 'Folders',
      ),
      CheckboxSettingsTile(
        settingKey: 'Impressum',
        title: 'Impressum',
      ),
      SettingsTileGroup(
        title: 'Song Settings',
        children: [
          CheckboxSettingsTile(
            settingKey: 'Short Press',
            title: 'Short Press',
          ),
          CheckboxSettingsTile(
            settingKey: 'Long Press',
            title: 'Long Press',
          ),
          CheckboxSettingsTile(
            settingKey: 'Action',
            title: 'Action',
          ),
        ],
      ),
      SettingsTileGroup(
        title: 'Album Settings',
        children: [
          CheckboxSettingsTile(
            settingKey: 'Short Press',
            title: 'Short Press',
          ),
          CheckboxSettingsTile(
            settingKey: 'Long Press',
            title: 'Long Press',
          ),
          CheckboxSettingsTile(
            settingKey: 'Action',
            title: 'Action',
          ),
        ],
      ),
    ]);
  }

  _showSettingsDialog() {
    return AlertDialog(
      title: Text('RadioButton'),
      content: RadioListTile(
        title: Text("Radio Text"),
        groupValue: 0,
        value: 1,
        onChanged: (val) {},
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
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
              setState(() {
                MusicFinder.instance.readFolderIntoDatabase(folder);
                folderLocation = folder.toString();
              });

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
}
