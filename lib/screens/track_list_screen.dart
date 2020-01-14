import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/main.dart';

class TrackList extends StatefulWidget {
  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  @override
  //final numItems = 20;
  List<Song> songs = List();




  Widget _buildRow(Song song) {

    @override
    void initState() async{
      super.initState();
      List<Song> loadSongs = await database.songDao.findAllSongs();
    }

    return ListTile(
      leading: CircleAvatar(
        child: Text(song.title),
      ),
      title: Text(song.artist),
      trailing: Icon(Icons.play_arrow),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return _buildRow(songs[index]);
        },
      ));
  }
}

