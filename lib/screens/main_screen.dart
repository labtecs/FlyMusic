import 'package:flutter/material.dart';
import 'package:flymusic/screens/drawer_screen.dart';
import 'package:flymusic/screens/track_list_screen.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        title: Text("FlyMusic - Tracks"),
      ),
      body: TrackList(),
    );
  }
}