import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/util/art_util.dart';

//TODO shuffle and repeat

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
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return getPortraitWidget(context);
          } else {
            return getLandscapeWidget(context);
          }
        }));
  }

  Widget getLandscapeWidget(BuildContext context) {
    double halfDisplaySize = MediaQuery.of(context).size.height - 50;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Hero(
              tag: 'imageHero',
              child: ArtUtil.getArtFromSongWithArt(
                  MusicQueue.instance.currentSong, context)),
          height: halfDisplaySize,
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                        MusicQueue.instance.currentSong?.song?.title ??
                            tr("unknown", context: context),
                        style: Theme.of(context).textTheme.headline4))),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                      MusicQueue.instance.currentSong?.song?.artistName ??
                          tr("unknown", context: context),
                      style: Theme.of(context).textTheme.headline5)),
            ),  Padding(
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //IconButton not working as expected here
                InkWell(
                  customBorder: CircleBorder(),
                  child: Icon(Icons.skip_previous,
                      size: 60, color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    MusicQueue.instance.playPrevious();
                  },
                ),
                InkWell(
                  customBorder: CircleBorder(),
                  child: Icon(getPlayIcon(),
                      size: 70, color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    MusicQueue.instance.playPause();
                  },
                ),
                InkWell(
                  customBorder: CircleBorder(),
                  child: Icon(Icons.skip_next,
                      size: 60, color: Theme.of(context).iconTheme.color),
                  onTap: () {
                    MusicQueue.instance.playNext();
                  }
                ),
              ],
            ),
          ],
        ))
      ],
    );
  }

  Widget getPortraitWidget(BuildContext context) {
    double halfDisplaySize = MediaQuery.of(context).size.height / 2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Hero(
              tag: 'imageHero',
              child: ArtUtil.getArtFromSongWithArt(
                  MusicQueue.instance.currentSong, context)),
          height: halfDisplaySize + 50,
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
        Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                    MusicQueue.instance.currentSong?.song?.title ??
                        tr("unknown", context: context),
                    style: Theme.of(context).textTheme.headline4))),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
          child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                  MusicQueue.instance.currentSong?.song?.artistName ??
                      tr("unknown", context: context),
                  style: Theme.of(context).textTheme.headline5)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //IconButton not working as expected here
            InkWell(
              customBorder: CircleBorder(),
              child: Icon(Icons.skip_previous,
                  size: 60, color: Theme.of(context).iconTheme.color),
              onTap: () {
                MusicQueue.instance.playPrevious();
              },
              splashColor: Theme.of(context).accentColor,
            ),
            InkWell(
              customBorder: CircleBorder(),
              child: Icon(getPlayIcon(),
                  size: 70, color: Theme.of(context).iconTheme.color),
              onTap: () {
                MusicQueue.instance.playPause();
              },
              splashColor: Theme.of(context).accentColor,
            ),
            InkWell(
              customBorder: CircleBorder(),
              child: Icon(Icons.skip_next,
                  size: 60, color: Theme.of(context).iconTheme.color),
              onTap: () {
                MusicQueue.instance.playNext();
              },
              splashColor: Theme.of(context).accentColor,
            ),
          ],
        ),
        Spacer()
      ],
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
