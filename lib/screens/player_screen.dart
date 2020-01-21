import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../database/model/song.dart';
import '../main.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  Song currentSong;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Image.memory(
          currentSong == null
              ? Uint8List(0)
              : Base64Decoder().convert(currentSong.songArt),
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              testPlay();
            },
            child: Icon(Icons.play_circle_outline)));
  }

  void testPlay() async {
   /* List<Song> songs = await database.songDao.findAllSongs();
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.setReleaseMode(ReleaseMode.STOP);
    int result = await audioPlayer.play(songs[0].uri, isLocal: true);
    if (result == 1) {
      // success
      setState(() {
        currentSong = songs[0];
      });
    }*/
  }
}
