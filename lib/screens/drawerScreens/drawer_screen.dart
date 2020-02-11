import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/screens/drawerScreens/impressum_screen.dart';
import 'package:flymusic/screens/drawerScreens/player_screen.dart';
import 'package:flymusic/screens/drawerScreens/settings_screen.dart';

class DrawerScreen extends StatefulWidget {

  bool akutelleWeidergabe = true;

  void showWiedergabe() {
    akutelleWeidergabe = true;
  }

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
            child: Text(getCurrentSongTitle(), 
              style: TextStyle(color: Colors.white),),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: getImage(MusicQueue.instance.currentSong),
              fit: BoxFit.fitWidth),
              color: Colors.blue,
            ),
          ),

          Visibility(
            visible: widget.akutelleWeidergabe,
            child: ListTile(
              title: Text('Aktuelle Wiedergabe'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => PlayerScreen()));
              },
            ),
          ),
          ListTile(
            title: Text('Einstellungen'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SettingsScreen()));
            },
          ),
          ListTile(
            title: Text("Impressum"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ImpressumScreen()));
            },
          ),
        ],
      ),
    );
  }

  String getCurrentSongTitle() {
    String songTitle;
    try{
      songTitle = MusicQueue.instance.currentSong.title;
      return songTitle;
    }
    catch (_){
      return " ";
    }
  }

  ImageProvider getImage(Song song) {
    if (song != null && song.songArt != null) {
      return MemoryImage(base64.decode(song.songArt));
    } else {
        return ExactAssetImage("asset/images/placeholder.jpg");
      }
    }
}
