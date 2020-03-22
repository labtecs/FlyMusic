import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/screens/player/player_screen.dart';
import 'package:flymusic/util/art_util.dart';

class BottomPlayer extends StatefulWidget {
  BottomPlayer();

  @override
  _BottomPlayerState createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> {
  Duration audioPosition = new Duration(seconds: 1);
  Duration duration = new Duration(seconds: 1);
  StreamSubscription onPlayerStateChanged;
  StreamSubscription onAudioPositionChanged;
  StreamSubscription onDurationChanged;

  _BottomPlayerState();

  @override
  void initState() {
    super.initState();
    onPlayerStateChanged =
        MusicQueue.instance.audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {});
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
          color: Colors.grey,
        ),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 65,
                child: InkWell(
                  child: Hero(
                      tag: 'imageHero',
                      child: ArtUtil.getArtFromSongWithArt(
                          MusicQueue.instance.currentSong, context)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlayerScreen()));
                  },
                ),
              ),
              GestureDetector(
                onHorizontalDragEnd: (DragEndDetails details) =>
                    _onHorizontalDrag(details),
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(MusicQueue.instance.currentSong?.song?.title ?? ""),
                        Text(MusicQueue.instance.currentSong?.song?.artistName ?? "")
                      ]),
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(getPlayIcon()),
                onPressed: () {
                  MusicQueue.instance.playPause();
                },
              ),
            ],
          ),
          SizedBox(height: 4.0, child: BottomPlayerProgress())
        ]));
  }

  IconData getPlayIcon() {
    if (MusicQueue.instance.audioPlayer.state == AudioPlayerState.PLAYING) {
      return Icons.pause_circle_outline;
    } else {
      return Icons.play_circle_outline;
    }
  }

  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity == 0)
      return; // user have just tapped on screen (no dragging)

    if (details.primaryVelocity.compareTo(0) == -1) {
      //dragged from left
      MusicQueue.instance.playPrevious();
    } else {
      //dragged from right
      MusicQueue.instance.playNext();
    }
  }
}

class BottomPlayerProgress extends StatefulWidget {
  BottomPlayerProgress();

  @override
  _BottomPlayerProgressState createState() => _BottomPlayerProgressState();
}

class _BottomPlayerProgressState extends State<BottomPlayerProgress> {
  Duration audioPosition = new Duration(seconds: 1);
  Duration duration = new Duration(seconds: 1);
  Duration rebuild = new Duration(seconds: 1);
  StreamSubscription onAudioPositionChanged;
  StreamSubscription onDurationChanged;

  _BottomPlayerProgressState();

  @override
  void initState() {
    super.initState();
    onAudioPositionChanged =
        MusicQueue.instance.audioPlayer.onAudioPositionChanged.listen((state) {
      //rebuild max 1 per second
      if ((audioPosition - state).abs() > rebuild) {
        setState(() {
          audioPosition = state;
        });
      }
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
    onAudioPositionChanged.cancel();
    onDurationChanged.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: audioPosition.inMilliseconds / duration.inMilliseconds,
      valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
      backgroundColor: Colors.black54,
    );
  }
}
