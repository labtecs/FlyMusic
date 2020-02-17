import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/screens/main_screen.dart';

//TODO next song?
class PlayerScreen extends StatefulWidget {
  PlayerScreen();

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

// TODO logic (warteliste)
class _PlayerScreenState extends State<PlayerScreen> {
  _PlayerScreenState();

  double postition = 0;
  @override
  Widget build(BuildContext context) {
    double halfDisplaySize = MediaQuery.of(context).size.height /2;
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
            child: StartScreen.getArt(MusicQueue.instance.currentSong?.artId),
            height: halfDisplaySize + 50,
          ),
          ListTile(
            title: Text(getTitle(),style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),),
            subtitle: Text(getArtist(), style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Slider(
              value: postition,
              onChanged: (value) {
                setState(() => postition = value);
              },
              min: 0,
              max: 100,
              label: "$postition",
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Container(
                  child: Icon(Icons.shuffle, size: 40,color: Colors.white),
                ),
                onTap: (){
                  shuffle();
                },
              ),
              InkWell(
                onTap: previous,
                child: Container(
                    child: Icon(Icons.skip_previous,size: 60,color: Colors.white)
                ),
              ),
              InkWell(
                onTap: () {
                  play();
                },
                child: Icon(getPlayIcon(), size: 70,color: Colors.white),
              ),
              InkWell(
                onTap: () {
                  next();
                },
                child: Icon(Icons.skip_next, size: 60,color: Colors.white),
              ),

              InkWell(
                onTap: () {
                  repeat();
                },
                child: Icon(Icons.repeat, size: 40,color: Colors.white),
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

  void shuffle() async {
    //Todo shuffle songs
  }

  void repeat() async {
    //Todo repeat song
  }

  String getTitle() {
    String title = "no title";
    try{
      title = MusicQueue.instance.currentSong.title;
      return title;
    }
    catch(q) {
      return title;

    }
  }
  String getArtist() {
    String artist = "no artist";
    try{
      artist = MusicQueue.instance.currentSong.artist;
      return artist;
    }
    catch(q) {
      return artist;
    }
  }
}
