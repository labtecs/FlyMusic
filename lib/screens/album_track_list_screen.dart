import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flymusic/database/model/album.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/main.dart';
import 'package:flymusic/screens/player_screen.dart';

import 'main_screen.dart';

class AlbumTrackListScreen extends StatefulWidget {

  String albumTitle;
  int albumID;
  AlbumTrackListScreen({Key key, this.albumTitle, this.albumID}) : super (key: key);
  @override
  _AlbumTrackListScreenState createState() => _AlbumTrackListScreenState();
}

class _AlbumTrackListScreenState extends State<AlbumTrackListScreen>{

  List<Song> songs = List();

  Widget _buildRow(Song song) {
    return ListTile(
      leading: CircleAvatar(
        child: StartScreen.getArt(song.artId),
        backgroundColor: Colors.transparent,
      ),
      title: Text(song.title),
      trailing: Icon(Icons.play_arrow),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayerScreen())
        );
      },
      onLongPress: () {
        Fluttertoast.showToast(
          msg: "${song.title}",
        );
      },
    );
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.albumTitle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("${widget.albumID}");
        },
        child: Icon(Icons.title),
      ),
      body: FutureBuilder<List<Song>>(
        future: database.songDao.findSongsByAlbumId(widget.albumID),
        builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
          if(snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return _buildRow(snapshot.data[index]);
                },
            );
          }
          else {
            return Text("no data");
          }
        },
      ),
    );
  }
}
