import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/screens/popupScreens/song_popup_screen.dart';
import 'package:flymusic/util/art_util.dart';
import 'package:provider/provider.dart';

class TrackList extends StatefulWidget {
  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  List<Song> songs = List();

  Widget _buildRow(Song song) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: ArtUtil.getArtFromSong(song, context),
          backgroundColor: Colors.transparent,
        ),
        title: Text(
          song.title,
          style: TextStyle(color: Colors.black),
        ),
        subtitle: Text(song.duration.toString(),
            style: TextStyle(color: Colors.black)),
        trailing: SongPopup(song),
        onTap: () {
          MusicQueue.instance.playSong(song);
        },
        onLongPress: () {
          MusicQueue.instance.addItem(song);
          Fluttertoast.showToast(
            msg: "${song.title} zur Warteliste hinzugefügt",
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Song>>(
        stream: Provider.of<SongDao>(context).findAllSongs(),
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
