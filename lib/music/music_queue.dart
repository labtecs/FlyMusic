import 'package:audioplayers/audioplayers.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/main.dart';

class MusicQueue {
  static final MusicQueue instance = MusicQueue._internal();

  factory MusicQueue() => instance;
  final AudioPlayer audioPlayer = AudioPlayer();

  QueueItem currentItem;
  Song currentSong;

  MusicQueue._internal() {
    audioPlayer.setReleaseMode(ReleaseMode.STOP);
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == AudioPlayerState.COMPLETED) {
        //TODO crossfade possible here
        playNext();
      }
    });
  }

  void playSongSwitchPlaylist(Song song) async {
    // 'Sofort Abspielen und zur Playlist wechseln'
  }

  void playSong(Song song) async {
    // 'Abspielen ohne Wechsel'
  }

  void addSong(Song song) async {
    //'An die Wiedergabeliste hinzufügen'
  }

  playItem(Object item) async {
    if (item is Song) {
      playSong(item);
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

    MyApp.db.queueItemDao.insert(
        QueueItem(id: null, position: newPosition, songId: song.id));
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
    var insertItems = items.map((id) =>
        new QueueItem(id: null, position: newPosition, songId: id));
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
    }
  }

  //warteschlange leer -> nächstes lied in "alle lieder"
  playPrevious() async {
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
    }
  }

  repeat() {}

  shuffle() {}

  void remove(QueueItem queueItem) async {
    // await MyApp.db.queueItemDao.deleteQueueItem(queueItem);
  }
}
