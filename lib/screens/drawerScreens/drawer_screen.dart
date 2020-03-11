import 'package:flutter/material.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/screens/drawerScreens/impressum_screen.dart';
import 'package:flymusic/screens/drawerScreens/settings_screen.dart';
import 'package:flymusic/screens/player/player_screen.dart';
import 'package:flymusic/screens/tabScreens/queue_screen.dart';
import 'package:flymusic/util/art_util.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ArtUtil.getArt2(MusicQueue.instance.currentSong),
          ListTile(
            title: Text('Aktuelle Wiedergabe'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PlayerScreen()));
            },
          ),
          ListTile(
            title: Text('Wiedergabeliste'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QueueScreen()));
            },
          ),
          ListTile(
            title: Text('Einstellungen'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
          ListTile(
            title: Text("Impressum"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ImpressumScreen()));
            },
          ),
        ],
      ),
    );
  }

  String getCurrentSongTitle() {
    String songTitle;
    try {
      songTitle = MusicQueue.instance.currentSong.title;
      return songTitle;
    } catch (_) {
      return " ";
    }
  }
}
