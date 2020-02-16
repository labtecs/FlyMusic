import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/main.dart';
import 'package:flymusic/screens/drawerScreens/player_screen.dart';
import 'package:flymusic/screens/popupScreens/songPopup_screen.dart';

import '../main_screen.dart';

class AlbumTrackListScreen extends StatefulWidget {

  String albumTitle;
  int albumID;
  int artID;

  AlbumTrackListScreen({Key key, this.albumTitle, this.albumID, this.artID}) : super (key: key);
  @override
  _AlbumTrackListScreenState createState() => _AlbumTrackListScreenState();
}

class _AlbumTrackListScreenState extends State<AlbumTrackListScreen>{

  List<Song> songs = List();

  Widget _buildRow(Song song, int idx) {
    return ListTile(
      leading: CircleAvatar(
        child: Text("$idx"),
    ),
      title: Text(song.title),
      subtitle: Text("00:00"),
      //Todo korrekte Zeit
      trailing: SongPopup(),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayerScreen())
        );
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
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        children: [
          SpeedDialChild(
              child: Icon(Icons.play_arrow),
              backgroundColor: Colors.blue,
              label: 'Abspielen',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('FIRST CHILD')
          ),
          SpeedDialChild(
            child: Icon(Icons.playlist_add),
            backgroundColor: Colors.blue,
            label: 'Warteschlange',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => print('SECOND CHILD'),
          ),
        ],
      ),
      body: NestedScrollView(
    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      return <Widget>[
        SliverAppBar(
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(widget.albumTitle,
                  style: TextStyle(color: Colors.white, fontSize: 16.0,
                  )
              ),
              background: StartScreen.getArt(widget.artID),
          ),
        ),
      ];
      },
        body: Center(
          child: FutureBuilder<List<Song>>(
            future: database.songDao.findSongsByAlbumId(widget.albumID),
            builder: (BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
              if(snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return _buildRow(snapshot.data[index], index+1);
                  },
                );
              }
              else {
                return Text("no data");
              }
            },
          ),
        ),
      ),
    );
  }
}
