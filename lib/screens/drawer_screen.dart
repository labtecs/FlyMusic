import 'package:flutter/material.dart';

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
          ),
          ListTile(
            title: Text('Alben'),
          ),
          ListTile(
            title: Text('Künstler'),
          )
        ],
      ),
    );
  }
}
