import 'package:flutter/material.dart';
import 'package:flymusic/screens/album_list_screen.dart';
import 'package:flymusic/screens/artist_screen.dart';
import 'package:flymusic/screens/main_screen.dart';
import 'package:flymusic/screens/track_list_screen.dart';

import 'player_screen.dart';

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
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),

          /*Jetzt über einen Klick auf einen Track erreichbar
          ListTile(
            title: Text('Player Screen'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerScreen()));
            },
          ),*/
          ListTile(
            title: Text('Lieder'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TrackList()));
            },
          ),
          ListTile(
            title: Text('Alben'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AlbumList()));
            },
          ),
          ListTile(
            title: Text('Künstler'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ArtistScreen()));
            },
          ),
          ListTile(
            title: Text('Einstellungen'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TrackList()));
            },
          ),
          ListTile(
            title: Text("Impressum"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TrackList()));
            },
          ),
        ],
      ),
    );
  }
}
