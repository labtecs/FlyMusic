import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/main.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/screens/drawerScreens/drawer_screen.dart';
import 'package:flymusic/screens/drawerScreens/player_screen.dart';
import 'package:flymusic/screens/main_screen.dart';

class TrackList extends StatefulWidget {
  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  List<Song> songs = List();

  Widget _buildRow(Song song) {
    return ListTile(
      leading: CircleAvatar(
        child: StartScreen.getArt(song.artId),
        backgroundColor: Colors.transparent,
      ),
      title: Text(song.title),
      trailing: Icon(Icons.play_arrow),
      onTap: () {
        DrawerScreen().showWiedergabe();
        MusicQueue.instance.playSong(song);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayerScreen()));
      },
      onLongPress: () {
        MusicQueue.instance.addSong(song);
        Fluttertoast.showToast(
          msg: "${song.title} zur Warteliste hinzugefügt",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<Song>>(
      stream: database.songDao.findAllSongs(),
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
    ));
  }
}
