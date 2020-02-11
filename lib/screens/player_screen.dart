import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flymusic/database/model/song.dart';

import '../music/music_queue.dart';

//TODO next song?
class PlayerScreen extends StatefulWidget {

  PlayerScreen();

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

// TODO logic (warteliste)
class _PlayerScreenState extends State<PlayerScreen> {

  _PlayerScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
        appBar: AppBar(
          title: Text(MusicQueue.instance.currentSong?.title ?? "no song"),
          backgroundColor: Colors.transparent,
          //elevation: 0.0, //Macht die Appbar komplett transparent.
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            getImage(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                    onPressed: () {
                      previous();
                    }, child: Icon(Icons.chevron_left, size: 80, color: Colors.white,)),
                MaterialButton(onPressed: () {
                  play();
                }, child: Icon(getPlayIcon(), size: 80, color: Colors.white,)),
                MaterialButton(
                    onPressed:  () {
                      next();
                    }, child: Icon(Icons.chevron_right, size: 80, color: Colors.white,))
              ],
            )
          ],
        ));
  }

  IconData getPlayIcon() {
    if (MusicQueue.instance.audioPlayer.state == AudioPlayerState.PLAYING) {
      return Icons.pause_circle_outline;
    } else {
      return Icons.play_circle_outline;
    }
  }

  Image getImage() {
    //Get Screen With
    double srceenWidth = MediaQuery.of(context).size.width;


    if (MusicQueue.instance.currentSong?.songArt != null) {
      return Image.memory(Base64Decoder().convert(MusicQueue.instance.currentSong.songArt),
          width: srceenWidth-30, height: srceenWidth-30, fit: BoxFit.contain);
    } else {
      return Image.asset("asset/images/placeholder.jpg");
    }
  }

  void play() async {
    await MusicQueue.instance.playPause();
    setState(() {
      MusicQueue.instance.audioPlayer.state =
          MusicQueue.instance.audioPlayer.state;
    });
  }

  void next() async {
    await MusicQueue.instance.playNext();
    setState(() {
      MusicQueue.instance.audioPlayer.state =
          MusicQueue.instance.audioPlayer.state;
    });
  }

  void previous() async {
    await MusicQueue.instance.playPrevious();
    setState(() {
      MusicQueue.instance.audioPlayer.state =
          MusicQueue.instance.audioPlayer.state;
    });
  }
}
