import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/screens/player/player_screen.dart';
import 'package:flymusic/screens/popupScreens/song_popup_screen.dart';
import 'package:flymusic/util/art_util.dart';
import 'package:provider/provider.dart';

class ArtistTrackListScreen extends StatefulWidget {
  final Artist artist;

  ArtistTrackListScreen({Key key, this.artist}) : super(key: key);

  @override
  _ArtistTrackListScreenState createState() => _ArtistTrackListScreenState();
}

class _ArtistTrackListScreenState extends State<ArtistTrackListScreen> {
  List<Song> songs = List();

  Widget _buildRow(Song song) {
    return ListTile(
      leading: CircleAvatar(
        child: ArtUtil.getArtFromSong(song, context),
        backgroundColor: Colors.transparent,
      ),
      title: Text(song.title),
      trailing: SongPopup(song),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayerScreen()));
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
                return _buildRow(snapshot.data[index]);
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
