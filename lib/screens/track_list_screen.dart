import 'package:flutter/material.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/main.dart';

class TrackList extends StatefulWidget {
  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  List<Song> songs = List();

  Widget _buildRow(Song song) {
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
    return Scaffold(
        body: FutureBuilder<List<Song>>(
      future: database.songDao.findAllSongs(),
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
}
