import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/screens/popupScreens/song_popup_screen.dart';
import 'package:flymusic/util/art_util.dart';
import 'package:flymusic/util/click_helper.dart';
import 'package:flymusic/util/shared_prefrences_util.dart';

Widget buildSongItem(Song song, BuildContext context) {
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
    subtitle:
        Text(song.duration.toString(), style: TextStyle(color: Colors.black)),
    trailing: SongPopup(song),
    onTap: () {
      if (SharedPreferencesUtil.instance.getBool(PrefKey.SHOW_POPUP)) {
        Fluttertoast.showToast(
          msg: "${song.title} zur Warteliste hinzugefügt",
        );
      }

      MusicQueue.instance.playSong(song);
    },
    onLongPress: () {
      onSongLongPress(song);
    },
  ));
}
