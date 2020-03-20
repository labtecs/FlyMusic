import 'package:fluttertoast/fluttertoast.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/util/shared_prefrences_util.dart';

onSongShortClick(Song song, int playlistId) async {
  switch (await SharedPreferencesUtil.instance
      .getString(PrefKey.SONG_SHORT_PRESS)) {
    case '1':
      await MusicQueue.instance.playSongSwitchPlaylist(song.id, playlistId);
      break;
    case '2':
      await MusicQueue.instance.playSong(song.id);
      break;
    case '3':
      await MusicQueue.instance.addSong(song.id, playlistId);

      Fluttertoast.showToast(
        msg: "${song.title} zur Warteliste hinzugefügt",
      );
      break;
  }
}

onSongLongPress(Song song, int playlistId) async {
  switch (
      await SharedPreferencesUtil.instance.getString(PrefKey.SONG_LONG_PRESS)) {
    case '1':
      await MusicQueue.instance.playSongSwitchPlaylist(song.id, playlistId);
      break;
    case '2':
      await MusicQueue.instance.playSong(song.id);
      break;
    case '3':
      await MusicQueue.instance.addSong(song.id, playlistId);

      Fluttertoast.showToast(
        msg: "${song.title} zur Warteliste hinzugefügt",
      );
      break;
  }
}

onSongActionButton(Song song, int playlistId) async {
  switch (await SharedPreferencesUtil.instance
      .getString(PrefKey.SONG_ACTION_BUTTON)) {
    case '1':
      //TODO    await MusicQueue.instance.playSongSwitchPlaylist(song);
      break;
    case '2':
      await MusicQueue.instance.playSong(song.id);
      break;
    case '3':
      await MusicQueue.instance.addSong(song.id, playlistId);

      Fluttertoast.showToast(
        msg: "${song.title} zur Warteliste hinzugefügt",
      );
      break;
  }
}
