import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/screens/tabScreens/queue_screen.dart';
import 'package:flymusic/util/art_util.dart';

class PlayerScreen extends StatefulWidget {
  PlayerScreen();

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  _PlayerScreenState();

  Duration audioPosition = new Duration();
  Duration duration = new Duration();
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

    onAudioPositionChanged = MusicQueue
        .instance.audioPlayer.onAudioPositionChanged
        .listen((state) => {
              setState(() {
                audioPosition = state;
              })
            });

    onDurationChanged =
        MusicQueue.instance.audioPlayer.onDurationChanged.listen((state) => {
              setState(() {
                duration = state;
              })
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
    double halfDisplaySize = MediaQuery.of(context).size.height / 2;
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        //Todo fix Button Overflow by rotating divce

        children: <Widget>[
          Container(
            child: Hero(
                tag: 'imageHero',
                child: ArtUtil.getArtFromSong(MusicQueue.instance.currentSong, context)),
            height: halfDisplaySize + 50,
          ),
          ListTile(
            title: Text(
              MusicQueue.instance.currentSong?.title ?? "no title",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              MusicQueue.instance.currentSong?.artist ?? "no artist",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            trailing: IconButton(
              icon: new Icon(
                Icons.queue_music,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QueueScreen()),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Slider(
              value: audioPosition.inSeconds?.toDouble() ?? 0,
              onChanged: (value) {
                MusicQueue.instance.audioPlayer
                    .seek(new Duration(seconds: value.toInt()));
              },
              min: 0,
              max: duration.inSeconds?.toDouble() ?? 0,
              label:
                  "${audioPosition.inSeconds?.toDouble() ?? 0} \ ${duration.inSeconds?.toDouble() ?? 0}",
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Container(
                  child: Icon(Icons.shuffle, size: 40, color: Colors.white),
                ),
                onTap: () {
                  MusicQueue.instance.shuffle();
                },
              ),
              InkWell(
                onTap: () {
                  MusicQueue.instance.playPrevious();
                },
                child: Container(
                  child:
                      Icon(Icons.skip_previous, size: 60, color: Colors.white),
                ),
              ),
              InkWell(
                onTap: () {
                  MusicQueue.instance.playPause();
                },
                child: Icon(getPlayIcon(), size: 70, color: Colors.white),
              ),
              InkWell(
                onTap: () {
                  MusicQueue.instance.playNext();
                },
                child: Icon(Icons.skip_next, size: 60, color: Colors.white),
              ),
              InkWell(
                onTap: () {
                  MusicQueue.instance.repeat();
                },
                child: Icon(Icons.repeat, size: 40, color: Colors.white),
              )
            ],
          )
        ],
      ),
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
