import 'package:fluttertoast/fluttertoast.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/util/shared_prefrences_util.dart';

/*
              '1': 'Sofort Abspielen',
              '2': 'Als nächstes Abspielen',
              '3': 'An die Wiedergabeliste hinzufügen',
              '-1': 'Keine Aktion'
 */
onSongShortClick(Song song) async {
  switch (await SharedPreferencesUtil.instance
      .getString(PrefKey.SONG_SHORT_PRESS)) {
    case '1':
      MusicQueue.instance.playSong(song);
      break;
    case '2':
      MusicQueue.instance.addSongNext(song);
      break;
    case '3':
      MusicQueue.instance.addItem(song);
      break;
  }
}

onSongLongPress(Song song) async {
  switch (
      await SharedPreferencesUtil.instance.getString(PrefKey.SONG_LONG_PRESS)) {
    case '1':
      MusicQueue.instance.playSong(song);
      break;
    case '2':
      MusicQueue.instance.addSongNext(song);
      break;
    case '3':
      MusicQueue.instance.addItem(song);
      break;
  }
}
onSongActionButton(Song song) async {

}

showPopup() async {
  if (await SharedPreferencesUtil.instance.getBool(PrefKey.SHOW_POPUP)) {
    Fluttertoast.showToast(
      msg: "zur Warteliste hinzugefügt",
    );
  }
}
