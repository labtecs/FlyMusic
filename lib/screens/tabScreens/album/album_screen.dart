import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/screens/popupScreens/song_popup_screen.dart';
import 'package:flymusic/screens/tabScreens/album/album_track_list_screen.dart';
import 'package:flymusic/util/art_util.dart';
import 'package:provider/provider.dart';

class AlbumList extends StatefulWidget {
  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {

  Widget _buildAlbumRow(Album album) {
    return ListTile(
      leading: CircleAvatar(
        child: ArtUtil.getArtFromAlbum(album, context),
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
            builder: (context) => AlbumTrackListScreen(key: null, album: album),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Album>>(
        stream: Provider.of<AlbumDao>(context).findAllAlbums(),
        builder: (BuildContext context, AsyncSnapshot<List<Album>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return _buildAlbumRow(snapshot.data[index]);
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
