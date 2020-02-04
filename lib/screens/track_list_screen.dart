import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/main.dart';
import 'package:flymusic/screens/player_screen.dart';

class TrackList extends StatefulWidget {
  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {

  List<Song> songs = List();

  Widget _buildRow(Song song) {
    return ListTile(
      leading: CircleAvatar(
        child: getImage(song),
        backgroundColor: Colors.transparent,
      ),
      title: Text(song.title),
      trailing: Icon(Icons.play_arrow),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayerScreen(song))
        );
      },
      onLongPress: () {
        Fluttertoast.showToast(
          msg: "${song.title}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black26,
          textColor: Colors.black,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<Song>>(
          stream: database.songDao.findAllSongs(),
          builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return _buildRow(snapshot.data[index]);
                },
              );
            } else {
              return Text("no data");
            }
          },
        ));
  }

  /*
  Überprüft ob ein Cover für das Lied vorhanden ist.
  Gibt andernfalls einen platzhalter zurück
   */
  Image getImage(Song song) {
    if (song != null && song.songArt != null) {
      return Image.memory(base64.decode(song.songArt));
    } else {
      return Image.asset( "asset/images/placeholder.jpg");
    }
  }
}




