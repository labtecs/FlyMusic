import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flymusic/music/music_finder.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'drawerScreens/drawer_screen.dart';
import 'player/bottom_player_screen.dart';
import 'tabScreens/album/album_screen.dart';
import 'tabScreens/artist/artist_screen.dart';
import 'tabScreens/queue_screen.dart';
import 'tabScreens/track_list_screen.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  Directory externalDirectory;

  int _page = 0;
  PageController _c;

  @override
  void initState() {
    _c = new PageController(
      initialPage: _page,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: BottomPlayer()
        ),
        title: ListTile(
          title: Text(
            getTitle(),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _page,
        //Add this line will fix the issue.
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          this._c.animateToPage(index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        },
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
              icon: new Icon(Icons.audiotrack), title: new Text("Tracks")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.album), title: new Text("Albums")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.person), title: new Text("Artists")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.list), title: new Text("Warteschlange")),
        ],
      ),
      body: new PageView(
        controller: _c,
        onPageChanged: (newPage) {
          setState(() {
            this._page = newPage;
          });
        },
        children: <Widget>[
          TrackList(),
          AlbumList(),
          ArtistScreen(),
          QueueScreen()
        ],
      ),
      // bottomSheet: BottomPlayer(),
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
              MusicFinder.instance.readFolderIntoDatabase(folder);
            });
      }));
    }
  }

  String getTitle() {
    switch (_page) {
      case 0:
        return 'Lied Liste';
      case 1:
        return 'Alben';
      case 2:
        return 'Künstler';
      case 3:
        return 'Warteschlange';
      default:
        return '';
    }
  }

  void onTapped(index) {
    setState(() {
      _page = index;
    });
  }
}
