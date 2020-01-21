import 'package:flutter/material.dart';
import 'package:flymusic/database/model/song.dart';

import '../main.dart';

class ArtistScreen extends StatefulWidget {
  @override
  _ArtistScreenState createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  @override

  List<Song> Artists = List();

  Widget _buildRow(Song song) {
    return ListTile(
      leading: CircleAvatar(
        child: Image.asset(checkCover(song.songArt)),
        backgroundColor: Colors.transparent,
      ),
      title: Text(song.title),
      trailing: Icon(Icons.play_arrow),
      onTap: () {
        print("Noch keine Funktion");
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
  String checkCover(String coverPath) {
    String testCover = "asset/images/artist_placeholder.jpg";
    if(coverPath == null) {
      return testCover;
    }
    else{
      return coverPath;
    }
  }
}