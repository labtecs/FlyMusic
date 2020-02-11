import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../music/music_finder.dart';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  Directory externalDirectory;
  bool _queueFirst = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Einstellungen"),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('Lied in der Warteschlange nach oben setzen'),
            value: _queueFirst,
            onChanged: (value) {
              setState(() {
                _queueFirst = value;
              });
              Fluttertoast.showToast(msg: 'not implemented yet');
            },
          ),
          ListTile(
            title: Text("Musik importieren"),
            subtitle: Text("noch nichts importiert"),
            trailing: Icon(Icons.more_vert),
            onTap: () {
              chooseFolder();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
      ),
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
                  print(folder);
                  MusicFinder.readFolderIntoDatabase(folder);
                });
          }));
    }
  }

}
