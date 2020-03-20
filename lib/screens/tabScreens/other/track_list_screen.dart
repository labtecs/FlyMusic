import 'package:flutter/material.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/screens/tabScreens/other/song_item.dart';
import 'package:provider/provider.dart';

class TrackList extends StatefulWidget {
  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Song>>(
        stream: Provider.of<SongDao>(context).findAllSongs(),
        builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return buildSongItem(snapshot.data[index], 1, context);
              },
            );
          } else {
            return Text("no data");
          }
        },
      ),
    );
  }
}
