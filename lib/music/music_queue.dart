import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/main.dart';
import 'package:flymusic/util/shared_prefrences_util.dart';

class MusicQueue {
  //TODO saved currently played song in shared prefs to know it after app close
  static final MusicQueue instance = MusicQueue._internal();

  factory MusicQueue() => instance;
  final AudioPlayer audioPlayer = AudioPlayer();

  QueueItem currentItem;
  SongWithArt currentSong;

  MusicQueue._internal() {
    if (!kIsWeb) {
      audioPlayer.setReleaseMode(ReleaseMode.STOP);
    }
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == AudioPlayerState.COMPLETED) {
        //TODO crossfade possible here
        playNext();
      }
    });
  }

  Future<void> playAlbum(Album album, BuildContext context) async {
    var song = await MyApp.db.songDao.findFirstSongsByAlbum(album);
    playSongSwitchPlaylist(song.id, album.playlistId, context);
  }

  Future<void> playSongSwitchPlaylist(
      int songId, int playlistId, BuildContext context) async {
    play() async {
      //remove old album (not manually added) and not current song (possible to click back if it is not removed)
      await MyApp.db.queueItemDao.clearNotManuallyQueue(currentItem?.id ?? -1);

      var items = await MyApp.db.playlistItemDao.findAllByPlaylist(playlistId);

      QueueItem lastItem = await MyApp.db.queueItemDao.getLastItemManually();

      var queueItemList = List<QueueItemsCompanion>();
      int position = lastItem?.position ?? 1;

      items.forEach((i) {
        if (!(i.playlistId == playlistId && i.songId == songId))
          queueItemList.add(QueueItemsCompanion.insert(
              position: ++position,
              isManuallyAdded: false,
              songId: i.songId,
              playlistId: i.playlistId));
      });
      await MyApp.db.queueItemDao.insertAll(queueItemList);

      //added items now directly play song
      playSong(songId, playlistId);
    }

    ask(BuildContext context) async {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Warteschlange leeren?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ja'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await MyApp.db.queueItemDao.clearQueue();
                  await play();
                },
              ),
              FlatButton(
                child: Text('Nein'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await play();
                },
              ),
            ],
          );
        },
      );
    }

    // 'Sofort Abspielen und zur Playlist wechseln'
    var clear = await SharedPreferencesUtil.instance
            .getString(PrefKey.QUEUE_CLEAR_OPTION) ==
        '2';

    if (clear) {
      var popup = await SharedPreferencesUtil.instance
          .getBool(PrefKey.QUEUE_WARNING_ON_CLEAR);
      if (popup) {
        var manuallyNotEmpty =
            await MyApp.db.queueItemDao.getAnyManuallyAddedItem() != null;
        if (manuallyNotEmpty) {
          await ask(context);
        } else {
          await MyApp.db.queueItemDao.clearQueue();
          await play();
        }
      } else {
        await MyApp.db.queueItemDao.clearQueue();
        await play();
      }
    } else {
      await play();
    }
  }

  Future<void> playSong(int songId, int playlistId) async {
    // 'Abspielen ohne Wechsel'
    int newPosition = 1;
    if (currentItem != null) {
      //einfach nach diesem item
      newPosition = currentItem.position + 1;
    }
    //position frei schieben (nächsten songs nach unten)
    await MyApp.db.queueItemDao.moveItemsDownFrom(newPosition);
    //einfügen
    var insertItem = QueueItemsCompanion.insert(
        position: newPosition,
        isManuallyAdded: true,
        songId: songId,
        playlistId: playlistId);
    var insertId = await MyApp.db.queueItemDao.insert(insertItem);
    var item = QueueItem(
        id: insertId,
        position: newPosition,
        isManuallyAdded: true,
        songId: songId,
        playlistId: playlistId);

    //abspielen
    var song = await MyApp.db.songDao.findSongByIdWithArt(songId);

    //update current item and song
    currentItem = item;
    currentSong = song;

    await audioPlayer.play(song.song.path, isLocal: true);
  }

  Future<void> addSong(int songId, int playlistId) async {
    //'An die Wiedergabeliste hinzufügen'
    var insertTop = await SharedPreferencesUtil.instance
            .getString(PrefKey.QUEUE_INSERT_OPTION) ==
        '1';
    //default oben
    int newPosition = 1;

    if (insertTop) {
      //kommt oben in die warteliste aber nach aktuellem song
      if (currentItem != null) {
        //einfach nach diesem item
        newPosition = currentItem.position + 1;
      }
    } else {
      //kommt unten in die Warteliste
      QueueItem lastItem = await MyApp.db.queueItemDao.getLastItemManually();
      if (lastItem != null) {
        newPosition = lastItem.position + 1;
      }
    }
    //position frei schieben
    await MyApp.db.queueItemDao.moveItemsDownFrom(newPosition);
    //einfügen
    await MyApp.db.queueItemDao.insert(QueueItemsCompanion.insert(
        position: newPosition,
        isManuallyAdded: true,
        songId: songId,
        playlistId: playlistId));
  }

  playPause() async {
    switch (audioPlayer.state) {
      case AudioPlayerState.PLAYING:
        await audioPlayer.pause();
        break;
      case AudioPlayerState.PAUSED:
        await audioPlayer.resume();
        break;
      default:
        await playNext();
        break;
    }
  }

  playNext() async {
    currentItem =
        await MyApp.db.queueItemDao.getNextItem(currentItem?.position ?? -1);
    if (currentItem == null) {
      return;
    }
    currentSong =
        await MyApp.db.songDao.findSongByIdWithArt(currentItem.songId);
    if (currentSong == null) {
      return;
    }
    int result = await audioPlayer.play(currentSong.song.path, isLocal: true);
    if (result != 1) {
      await playNext();
    }
  }

  playPrevious() async {
    currentItem =
        await MyApp.db.queueItemDao.getPreviousItem(currentItem?.position ?? 1);
    if (currentItem == null) {
      return;
    }
    currentSong =
        await MyApp.db.songDao.findSongByIdWithArt(currentItem.songId);
    if (currentSong == null) {
      return;
    }
    int result = await audioPlayer.play(currentSong.song.path, isLocal: true);
    if (result != 1) {
      await playPrevious();
    }
  }

  void remove(QueueItem queueItem) async {
    await MyApp.db.queueItemDao.deleteQueueItem(queueItem);
  }

  //TODO
  repeat() {}

  //TODO
  shuffle() {}
}
