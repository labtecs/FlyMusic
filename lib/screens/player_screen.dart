import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flymusic/database/model/song.dart';

//TODO next song?
class PlayerScreen extends StatefulWidget {
  Song _song;

  PlayerScreen(this._song);

  @override
  _PlayerScreenState createState() => _PlayerScreenState(_song);
}

// TODO logic (warteliste)
class _PlayerScreenState extends State<PlayerScreen> {
  Song _currentSong;
  AudioPlayer audioPlayer = AudioPlayer();

  _PlayerScreenState(this._currentSong);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_currentSong == null ? "no song" : _currentSong.title),
          backgroundColor: Colors.transparent,
          //elevation: 0.0, //Macht die Appbar komplett transparent.
        ),
        body: Column(
          children: <Widget>[
            getImage(),
            Row(
              children: <Widget>[
                MaterialButton(
                    onPressed: null, child: Icon(Icons.chevron_left)),
                MaterialButton(onPressed: () {
                  play();
                }, child: Icon(getPlayIcon())),
                MaterialButton(
                    onPressed: null, child: Icon(Icons.chevron_right))
              ],
            )
          ],
        ));
  }

  IconData getPlayIcon() {
    if (audioPlayer.state == AudioPlayerState.PLAYING) {
      return Icons.pause_circle_outline;
    } else {
      return Icons.play_circle_outline;
    }
  }

  Image getImage() {
    if (_currentSong != null && _currentSong.songArt != null) {
      return Image.memory(Base64Decoder().convert(_currentSong.songArt),
          width: 100, height: 100, fit: BoxFit.contain);
    } else {
      return Image.asset("asset/images/placeholder.jpg");
    }
  }

  void play() async {
    await audioPlayer.setReleaseMode(ReleaseMode.STOP);
    if (audioPlayer.state == AudioPlayerState.PLAYING){
      await audioPlayer.pause();
    }else{
      int result = await audioPlayer.play(_currentSong.uri, isLocal: true);
      //TODO result problem -> go to next song
    }
    setState(() {
      audioPlayer.state = audioPlayer.state;
    });
  }
}
