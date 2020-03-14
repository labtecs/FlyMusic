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
        //  Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => PlayerScreen()));
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

  FutureBuilder getBuilder() {
    return FutureBuilder<List<Song>>(
      future: database.songDao.findSongsByAlbumId(widget.album.id),
      // this is a code smell. Make sure that the future is NOT recreated when build is called. Create the future in initState instead.
      builder: (context, snapshot) {
        Widget newsListSliver;
        if (snapshot.hasData) {
          newsListSliver = SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _buildRow(
                snapshot.data[index],
                index + 1,
              );
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
          child: ArtUtil.getArtFromAlbum(album),
        ),
        Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.black54,
                child: Container(
                  height: kToolbarHeight,
                  child: Center(
                    child: Text(
                      album.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 23,
                      ),
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
    print("num $num shrink $shrinkOffset");
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
