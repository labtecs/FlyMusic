import 'package:flutter/material.dart';

import '../database/model/song.dart';
import '../main.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              testPlay();
            },
            child: Icon(Icons.play_circle_outline))
    );
  }

  void testPlay() async {
    List<Song> songs = await database.songDao.findAllSongs();
    AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    int result = await audioPlayer.play(songs[0].uri);
    if (result == 1) {
      // success
    }
  }

}