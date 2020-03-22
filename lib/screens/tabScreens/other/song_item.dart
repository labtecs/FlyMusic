import 'package:flutter/material.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/util/art_util.dart';
import 'package:flymusic/util/click_helper.dart';
import 'package:flymusic/util/shared_prefrences_util.dart';

Widget buildSongItem(Song song, int playlistId, BuildContext context) {
  return Container(
      child: ListTile(
    leading: CircleAvatar(
      child: ArtUtil.getArtFromSong(song, context),
      backgroundColor: Colors.transparent,
    ),
    title: Text(
      song.title,
      style: TextStyle(color: Colors.black),
    ),
    subtitle: Text(timestamp(Duration(milliseconds: song.duration)),
        style: TextStyle(color: Colors.black)),
    trailing: getTrailingIcon(song, playlistId),
    onTap: () {
      onSongShortClick(song, playlistId, context);
    },
    onLongPress: () {
      onSongLongPress(song, playlistId, context);
    },
  ));
}

String timestamp(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String hours(int n) {
    if (n > 0) return "$n:";
    return "";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${hours(duration.inHours)}$twoDigitMinutes:$twoDigitSeconds";
}

Widget getTrailingIcon(Song song, int playlistId) {
  Future<String> getFuture() async {
    return await SharedPreferencesUtil().getString(PrefKey.SONG_ACTION_BUTTON);
  }

  return FutureBuilder<String>(
      future: getFuture(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data != '-1') {
          IconData icon;
          switch (snapshot.data) {
            case '1':
              //Sofort Abspielen und zur Playlist wechseln
              icon = Icons.play_circle_filled;

              break;
            case '2':
              //Abspielen ohne Wechsel
              icon = Icons.play_circle_outline;
              break;
            case '3':
              //An die Wiedergabeliste hinzufügen
              icon = Icons.playlist_add;
              break;
          }
          return IconButton(
              icon: Icon(icon),
              onPressed: () {
                onSongActionButton(song, playlistId, context);
              });
        } else {
          return Container(
            height: 0,
            width: 0,
          );
        }
      });
}
