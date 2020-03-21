import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/main.dart';
import 'package:flymusic/util/shared_prefrences_util.dart';

class MusicQueue {
  //TODO saved currently played song in shared prefs to reget it (position in qitems)
  static final MusicQueue instance = MusicQueue._internal();

  factory MusicQueue() => instance;
  final AudioPlayer audioPlayer = AudioPlayer();

  QueueItem currentItem;
  Song currentSong;

  MusicQueue._internal() {
    if(!kIsWeb){
      audioPlayer.setReleaseMode(ReleaseMode.STOP);
    }
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == AudioPlayerState.COMPLETED) {
        //TODO crossfade possible here
        playNext();
      }
    });
  }

  void playSongSwitchPlaylist(int songId, int playlistId) async {
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
          //TODO ask and wait
        } else {
          await MyApp.db.queueItemDao.clearQueue();
        }
      } else {
        await MyApp.db.queueItemDao.clearQueue();
      }
    }

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

  void playSong(int songId, int playlistId) async {
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
    var song = await MyApp.db.songDao.findSongById(songId);

    //update current item and song
    currentItem = item;
    currentSong = song;

    await audioPlayer.play(song.path, isLocal: true);
  }

  void addSong(int songId, int playlistId) async {
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
        position: newPosition, isManuallyAdded: true, songId: songId, playlistId: playlistId));
  }

  playItem(Object item) async {
    if (item is Song) {
      // playSong(item);
    } else if (item is Album) {
      playAlbum(item);
    } else if (item is Artist) {
      playArtist(item);
    }
  }

  playItemNext(Object item) async {
    if (item is Song) {
    } else if (item is Album) {
    } else if (item is Artist) {}
  }

  addItem(Object item) async {
    if (item is Song) {
      _addSong(item);
    } else if (item is Album) {
      _addAlbum(item);
    } else if (item is Artist) {
      _addArtist(item);
    }
  }

  /*
    //kommt oben in die warteschlange die anderen lieder werden nach unten verschoben
    MyApp.db.queueItemDao.moveItemsDownBy(1);
    MyApp.db.queueItemDao
        .insert(QueueItem(id: null, position: 0, songId: song.id));
    if (audioPlayer.state == AudioPlayerState.PLAYING) {
      await audioPlayer.stop();
    }
    await playPause();*/

  playAlbum(Album album) async {
    await clear();
    await _addAlbum(album);
    await playIfNotPlaying();
  }

  playArtist(Artist artist) async {
    await clear();
    await _addArtist(artist);
    await playIfNotPlaying();
  }

  _addSong(Song song) async {
    //kommt unten in die Warteliste
    QueueItem lastItem = await MyApp.db.queueItemDao.getLastItem();
    int newPosition = 0;
    if (lastItem != null) {
      newPosition = lastItem.position + 1;
    }

    MyApp.db.queueItemDao
        .insert(QueueItem(id: null, position: newPosition, songId: song.id));
  }

  addSongNext(Song song) async {
    //kommt unten in die Warteliste
    //TODO
//    QueueItem lastItem = await database.queueDao.getLastItem();
//    database.queueDao
//        .addItem(new QueueItem(null, song.id, lastItem?.position++ ?? 0));
  }

  playIfNotPlaying() async {
    if (audioPlayer.state != AudioPlayerState.PLAYING) {
      await playPause();
    }
  }

  clear() {}

  _addAlbum(Album album) async {
    //alle lieder in die warteschlange (unten)
    _addItems((await MyApp.db.songDao.findSongsByAlbum(album))
        .map((item) => item.id)
        .toList());
  }

  _addArtist(Artist artist) async {
    //alle lieder in die warteschlange (unten)
    _addItems((await MyApp.db.songDao.findSongsByArtist(artist))
        .map((item) => item.id)
        .toList());
  }

  _addItems(List<int> items) async {
    var lastItem = await MyApp.db.queueItemDao.getLastItem();
    int newPosition = 0;
    if (lastItem != null) {
      newPosition = lastItem.position + 1;
    }
    var insertItems = items.map(
        (id) => new QueueItem(id: null, position: newPosition, songId: id));
    MyApp.db.queueItemDao.insertAll(insertItems.toList());
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

  //20 lieder vor dem aktuellen - davor löschen TODO
  playNext() async {
    /*
    currentItem =
        await MyApp.db.queueItemDao.getNextItem(currentItem?.position ?? -1);
    if (currentItem == null) {
      return;
    }
    currentSong = await MyApp.db.songDao.findSongById(currentItem.songId);
    if (currentSong == null) {
      return;
    }
    int result = await audioPlayer.play(currentSong.path, isLocal: true);
    if (result != 1) {
      await playNext();
    }*/
  }

  //warteschlange leer -> nächstes lied in "alle lieder"
  playPrevious() async {
    /*
    currentItem =
        await MyApp.db.queueItemDao.getPreviousItem(currentItem?.position ?? 1);
    if (currentItem == null) {
      return;
    }
    currentSong = await MyApp.db.songDao.findSongById(currentItem.songId);
    if (currentSong == null) {
      return;
    }
    int result = await audioPlayer.play(currentSong.path, isLocal: true);
    if (result != 1) {
      await playPrevious();
    }*/
  }

  repeat() {}

  shuffle() {}

  void remove(QueueItem queueItem) async {
    // await MyApp.db.queueItemDao.deleteQueueItem(queueItem);
  }
}
