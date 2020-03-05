import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/screens/main_screen.dart';

class BottomPlayer extends StatefulWidget {
  @override
  _BottomPlayerState createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> {
  Duration audioPosition;
  Duration duration;
  StreamSubscription onPlayerStateChanged;
  StreamSubscription onAudioPositionChanged;
  StreamSubscription onDurationChanged;

  @override
  void initState() {
    super.initState();
    onPlayerStateChanged =
        MusicQueue.instance.audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {});
    });

    onAudioPositionChanged =
        MusicQueue.instance.audioPlayer.onAudioPositionChanged.listen((state) {
      setState(() {
        audioPosition = state;
      });
    });

    onDurationChanged =
        MusicQueue.instance.audioPlayer.onDurationChanged.listen((state) {
      setState(() {
        duration = state;
      });
    });
  }

  @override
  void dispose() {
    onPlayerStateChanged.cancel();
    onAudioPositionChanged.cancel();
    onDurationChanged.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black)),
          color: Colors.grey),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                child: StartScreen.getArt3(MusicQueue.instance.currentSong?.artId, 10),
              ),
              IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: () {
                  MusicQueue.instance.playPrevious();
                },
              ),
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {
                  MusicQueue.instance.playPause();
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () {
                  MusicQueue.instance.playNext();
                },
              ),
            ],
          )),
    );
  }

  IconData getPlayIcon() {
    if (MusicQueue.instance.audioPlayer.state == AudioPlayerState.PLAYING) {
      return Icons.pause_circle_outline;
    } else {
      return Icons.play_circle_outline;
    }
  }
}
