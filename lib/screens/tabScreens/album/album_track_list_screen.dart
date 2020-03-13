import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flymusic/database/model/album.dart';
import 'package:flymusic/database/model/song.dart';
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

  Widget _buildRow(Song song, int idx) {
    return ListTile(
      leading: CircleAvatar(
        child: Text("$idx"),
        backgroundColor: Colors.black54,
      ),
      title: Text(song.title),
      subtitle: Text("00:00"),
      //Todo korrekte Zeit
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
    return SafeArea(
      child: Material(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(expandedHeight: 200, album: widget.album),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) => ListTile(
                  title: Text("Index: $index"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

/*
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text(widget.album.name),
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.black54,
                flexibleSpace: Stack(
                  children: <Widget>[
                    Positioned.fill(
                        child:  ArtUtil.getArtFromAlbum(widget.album)),
                  ],
                ),
              ),
            ];
          },
          body: Column(children: <Widget>[
            new Text('LISTA',
                style: new TextStyle(
                  fontSize: 15.2,
                  fontWeight: FontWeight.bold,
                )),
            new Expanded(
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
              ),
            ),
          ])),
    );
  }*/
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Album album;

  MySliverAppBar({@required this.expandedHeight,@required this.album});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        ArtUtil.getArtFromAlbum(album),
        Center(
            child: Text(
              album.name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
          ),
        ),
        Positioned(
          top: getTop(expandedHeight, shrinkOffset),
          right: MediaQuery.of(context).size.width / 5,
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0)),
            onPressed: () {},
            color: Colors.blue,
            child: Text(
              "play",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
          ),
        ),
      ],
    );
  }

  double getTop(double expandedHeight, double shrinkOffset) {
    double num = 200 - 27 - shrinkOffset;
    print("num $num shrink $shrinkOffset");
    if (num < 27) {
      num = 27;
    }
    return num;
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
