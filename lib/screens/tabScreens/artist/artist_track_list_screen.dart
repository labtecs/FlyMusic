import 'package:flutter/material.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/screens/tabScreens/other/song_item.dart';
import 'package:provider/provider.dart';

class ArtistTrackListScreen extends StatefulWidget {
  final Artist artist;

  ArtistTrackListScreen({Key key, this.artist}) : super(key: key);

  @override
  _ArtistTrackListScreenState createState() => _ArtistTrackListScreenState();
}

class _ArtistTrackListScreenState extends State<ArtistTrackListScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.artist.name),
        backgroundColor: Colors.black54,
      ),
      body: FutureBuilder<List<Song>>(
        future: Provider.of<SongDao>(context).findSongsByArtist(widget.artist),
        builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return buildSongItem(snapshot.data[index], widget.artist.playlistId, context);
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
