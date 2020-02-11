import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/screens/drawerScreens/impressum_screen.dart';
import 'package:flymusic/screens/drawerScreens/player_screen.dart';
import 'package:flymusic/screens/drawerScreens/settings_screen.dart';

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
          DrawerHeader(
            child: Text('Aktueller Songtitel'),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: getImage(MusicQueue.instance.currentSong),
              fit: BoxFit.fitWidth),
              color: Colors.blue,
            ),
          ),

          //Jetzt über einen Klick auf einen Track erreichbar
          ListTile(
            title: Text('Aktuelle Wiedergabe'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerScreen()));
            },
          ),
          ListTile(
            title: Text('Einstellungen'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
          ListTile(
            title: Text("Impressum"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ImpressumScreen()));
            },
          ),
        ],
      ),
    );
  }

  ImageProvider getImage(Song song) {
    if (song != null && song.songArt != null) {
      return MemoryImage(base64.decode(song.songArt));
    } else {
      return FileImage(File("asset/images/placeholder.jpg"));
    }
  }
}
