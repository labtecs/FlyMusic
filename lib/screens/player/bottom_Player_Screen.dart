import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/screens/main_screen.dart';


class BottomPlayer extends StatefulWidget {
  @override
  _BottomPlayerState createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black)),
          color: Colors.grey
      ),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                child: StartScreen.getArt3(MusicQueue.instance.currentSong, 10),
              ),
              IconButton(
                icon: Icon(Icons.skip_previous),
                onPressed: () {
                  Fluttertoast.showToast(msg: "klick");
                },
              ),
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {
                  Fluttertoast.showToast(msg: "klick");
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () {
                  Fluttertoast.showToast(msg: "klick");
                },
              ),
            ],
          )
      ),
    );

  }


}
