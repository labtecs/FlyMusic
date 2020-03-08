import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flymusic/database/model/album.dart';
import 'package:flymusic/main.dart';
import 'package:flymusic/screens/player/bottom_player_screen.dart';
import 'package:flymusic/screens/popupScreens/song_popup_screen.dart';
import 'package:flymusic/screens/tabScreens/album/album_track_list_screen.dart';
import 'package:flymusic/util/art_util.dart';

class AlbumList extends StatefulWidget {
  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  List<Album> albems = List();

  Widget _buildRow(Album album) {
    return ListTile(
      leading: CircleAvatar(
        child: ArtUtil.getArtFromAlbum(album),
        backgroundColor: Colors.transparent,
      ),
      title: Text(album.name),
      trailing: SongPopup(album),
      onLongPress: () {
        Fluttertoast.showToast(msg: "${album.name}");
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumTrackListScreen(
                key: null,
                album: album),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Album>>(
        future: database.albumDao.findAllAlbums(),
        builder: (BuildContext context, AsyncSnapshot<List<Album>> snapshot) {
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
