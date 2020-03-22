import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/util/shared_prefrences_util.dart';

onSongShortClick(Song song, int playlistId, BuildContext context) async {
  await doAction(PrefKey.SONG_SHORT_PRESS, song, playlistId, context);
}

onSongLongPress(Song song, int playlistId, BuildContext context) async {
  await doAction(PrefKey.SONG_LONG_PRESS, song, playlistId, context);
}

onSongActionButton(Song song, int playlistId, context) async {
  await doAction(PrefKey.SONG_ACTION_BUTTON, song, playlistId, context);
}

doAction(PrefKey pref, Song song, int playlistId, context) async {
  switch (await SharedPreferencesUtil.instance.getString(pref)) {
    case '1':
      await MusicQueue.instance
          .playSongSwitchPlaylist(song.id, playlistId, context);
      break;
    case '2':
      await MusicQueue.instance.playSong(song.id, playlistId);
      break;
    case '3':
      await MusicQueue.instance.addSong(song.id, playlistId);

      Fluttertoast.showToast(
        msg: "${song.title} zur Warteliste hinzugefügt",
      );
      break;
  }
}
