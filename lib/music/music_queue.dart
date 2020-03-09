import 'package:audioplayers/audioplayers.dart';
import 'package:flymusic/database/model/album.dart';
import 'package:flymusic/database/model/artist.dart';
import 'package:flymusic/database/model/queue_item.dart';
import 'package:flymusic/database/model/song.dart';
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

  playSong(Song song) async {
    //kommt oben in die warteschlange die anderen lieder werden nach unten verschoben
    database.queueDao.moveItemsDownBy(1);
    database.queueDao.addItem(new QueueItem(null, song.id, 0));
    if (audioPlayer.state == AudioPlayerState.PLAYING) {
      await audioPlayer.stop();
    }
    await playPause();
  }

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
    QueueItem lastItem = await database.queueDao.getLastItem();
    database.queueDao
        .addItem(new QueueItem(null, song.id, lastItem?.position++ ?? 0));
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
    _addItems((await database.songDao.findSongIdsByAlbumId(album.id))
        .map((item) => item.id)
        .toList());
  }

  _addArtist(Artist artist) async {
    //alle lieder in die warteschlange (unten)
    _addItems((await database.songDao.findSongIdsByArtistId(artist.id))
        .map((item) => item.id)
        .toList());
  }

  _addItems(List<int> items) async {
    var lastItem = await database.queueDao.getLastItem();
    var insertItems =
        items.map((id) => new QueueItem(null, id, lastItem?.position++ ?? 0));
    database.queueDao.addItems(insertItems.toList());
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
        await database.queueDao.getNextItem(currentItem?.position ?? -1);
    if (currentItem == null) {
      return;
    }
    currentSong = await database.songDao.findSongById(currentItem.songId);
    if (currentSong == null) {
      return;
    }
    int result = await audioPlayer.play(currentSong.uri, isLocal: true);
    if (result != 1) {
      await playNext();
    }
  }

  //warteschlange leer -> nächstes lied in "alle lieder"
  playPrevious() async {
    currentItem =
        await database.queueDao.getPreviousItem(currentItem?.position ?? 1);
    if (currentItem == null) {
      return;
    }
    currentSong = await database.songDao.findSongById(currentItem.songId);
    if (currentSong == null) {
      return;
    }
    int result = await audioPlayer.play(currentSong.uri, isLocal: true);
    if (result != 1) {
      await playPrevious();
    }
  }

  repeat() {}

  shuffle() {}

  void remove(QueueItem queueItem) async {
    await database.queueDao.remove(queueItem);
  }
}
