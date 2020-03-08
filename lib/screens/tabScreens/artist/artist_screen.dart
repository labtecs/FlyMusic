import 'package:flutter/material.dart';
import 'package:flymusic/database/model/artist.dart';
import 'package:flymusic/main.dart';
import 'package:flymusic/screens/player/bottom_player_screen.dart';
import 'package:flymusic/screens/popupScreens/song_popup_screen.dart';
import 'package:flymusic/screens/tabScreens/artist/artist_track_list_screen.dart';

class ArtistScreen extends StatefulWidget {
  @override
  _ArtistScreenState createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {

  Widget _buildRow(Artist artist) {
    return ListTile(
      leading: CircleAvatar(
        child: Image.asset("asset/images/artist_placeholder.jpg"),
        backgroundColor: Colors.transparent,
      ),
      title: Text(artist.name),
      trailing: SongPopup(artist),
      onTap: () {
        Navigator.push
          (context, MaterialPageRoute(builder: (context) =>
            ArtistTrackListScreen(
              key: null, artistName: artist.name, artistID: artist.id,
            ),
        ),
        );
      },

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<Artist>>(
      stream: database.artistDao.findAllArtists(),
      builder: (BuildContext context, AsyncSnapshot<List<Artist>> snapshot) {
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

  /*
  Überprüft ob ein Cover für das Lied vorhanden ist.
  Gibt andernfalls einen platzhalter zurück
   */
  String checkCover(String coverPath) {
    String testCover = "asset/images/artist_placeholder.jpg";
    if (coverPath == null) {
      return testCover;
    } else {
      return coverPath;
    }
  }
}
