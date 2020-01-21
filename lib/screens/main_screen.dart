import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flymusic/screens/drawer_screen.dart';
import 'package:flymusic/screens/track_list_screen.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../music/music_finder.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Directory externalDirectory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        title: Text("FlyMusic - Tracks"),
      ),
      body: TrackList(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            chooseFolder();
          },
          child: Icon(Icons.folder)),
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
              MusicFinder.readFolderIntoDatabase(folder);
              Navigator.of(context).pop();
            });
      }));
    }
  }

  Future<void> getStorage() async {
    final directory =
        await getExternalStorageDirectories(type: StorageDirectory.music);
    setState(() => externalDirectory = directory[1]);
  }
}
