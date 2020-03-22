import 'package:flutter/material.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/screens/player/player_screen.dart';
import 'package:flymusic/screens/tabScreens/other/song_item.dart';
import 'package:flymusic/util/art_util.dart';
import 'package:provider/provider.dart';

class AlbumTrackListScreen extends StatefulWidget {
  final Album album;

  AlbumTrackListScreen({Key key, this.album}) : super(key: key);

  @override
  _AlbumTrackListScreenState createState() => _AlbumTrackListScreenState();
}

class _AlbumTrackListScreenState extends State<AlbumTrackListScreen> {
  List<Song> songs = List();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate:
                  MySliverAppBar(expandedHeight: 350, album: widget.album),
              pinned: true,
            ),
            getBuilder()
          ],
        ),
      ),
    );
  }

  StreamBuilder getBuilder() {
    return StreamBuilder<List<SongWithArt>>(
      stream:
          Provider.of<SongDao>(context).findSongsByAlbumWithArt(widget.album),
      // this is a code smell. Make sure that the future is NOT recreated when build is called. Create the future in initState instead.
      builder: (context, snapshot) {
        Widget newsListSliver;
        if (snapshot.hasData) {
          newsListSliver = SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              return buildSongItem(
                  snapshot.data[index], widget.album.playlistId, context);
            },
            childCount: snapshot.data.length,
          ));
        } else {
          newsListSliver = SliverToBoxAdapter(
            child: CircularProgressIndicator(),
          );
        }
        return newsListSliver;
      },
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Album album;

  MySliverAppBar({@required this.expandedHeight, @required this.album});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                    stops: [0.6, 1])
                .createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
          },
          blendMode: BlendMode.dstIn,
          child: ArtUtil.getArtFromAlbum(album, context),
        ),
        Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.black54,
                child: Container(
                  height: kToolbarHeight,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    title: Text(
                      album.name,
                    ),
                  ),
                ),
              ),
            ]),
        Positioned(
          top: getTop(expandedHeight, shrinkOffset),
          right: MediaQuery.of(context).size.width / 5,
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PlayerScreen()));
            },
            color: Colors.blue,
            child: Text(
              "play",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 23,
              ),
            ),
          ),
        ),
      ],
    );
  }

  double getTop(double expandedHeight, double shrinkOffset) {
    double num = expandedHeight - 50 - shrinkOffset;

    if (num < kToolbarHeight) {
      num = kToolbarHeight;
    }
    return num;
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 45;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
