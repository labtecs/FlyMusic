import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flymusic/database/model/album.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/main.dart';
import 'package:flymusic/screens/player/player_screen.dart';
import 'package:flymusic/screens/popupScreens/song_popup_screen.dart';
import 'package:flymusic/util/art_util.dart';

class AlbumTrackListScreen extends StatefulWidget {
  final Album album;

  AlbumTrackListScreen({Key key, this.album}) : super(key: key);

  @override
  _AlbumTrackListScreenState createState() => _AlbumTrackListScreenState();
}

class _AlbumTrackListScreenState extends State<AlbumTrackListScreen> {
  List<Song> songs = List();
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _scrollController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildRow(Song song, int idx) {
    return ListTile(
      leading: CircleAvatar(
        child: Text("$idx"),
        backgroundColor: Colors.black54,
      ),
      title: Text(song.title),
      subtitle: Text(song.duration.toString()),
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(children: <Widget>[
      new CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100.0),
                child: Expanded(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.black26),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Chip(label: Text("Dfsdf")),
                          Text(widget.album.name,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0))
                        ]),
                  ),
                )),
            backgroundColor: Colors.black54,
            flexibleSpace: FlexibleSpaceBar(
              background: ArtUtil.getArtFromAlbum(widget.album),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                  child: FutureBuilder<List<Song>>(
                future: database.songDao.findSongsByAlbumId(widget.album.id),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return _buildRow(
                          snapshot.data[index],
                          index + 1,
                        );
                      },
                    );
                  } else {
                    return Text("no data, or loading");
                  }
                },
              ))
            ]),
          ),
        ],
      ),
      new Positioned(
        top: 256.0,
        right: 16.0,
        child: new FloatingActionButton(
          onPressed: () {},
          child: new Icon(Icons.add),
        ),
      ),
    ]));
  }
}
