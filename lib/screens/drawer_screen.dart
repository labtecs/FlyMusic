import 'package:flutter/material.dart';
import 'package:flymusic/screens/impressum_screen.dart';
import 'package:flymusic/screens/player_screen.dart';
import 'package:flymusic/screens/settings_screen.dart';

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
                image: ExactAssetImage('asset/images/placeholder.jpg'),
                fit: BoxFit.cover,
              ),
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
}
