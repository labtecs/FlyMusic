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
  Song _currentSong;

  MusicQueue._internal() {
    audioPlayer.setReleaseMode(ReleaseMode.STOP);
  }

  playAlbum(Album album) {
    //alle lieder in die warteschlange (oben)
  }

  playArtist(Artist artist) {
    //alle lieder in die warteschlange (oben)
  }

  playSong(Song song) {
    //kommt oben in die warteschlange die anderen lieder werden nach unten verschoben
  }

  addAlbum(Album album) async {
    //alle lieder in die warteschlange (unten)
    addItems(await database.songDao.findSongIdsByAlbumId(album.id));
  }

  addArtist(Artist artist) async {
    //alle lieder in die warteschlange (unten)
    addItems(await database.songDao.findSongIdsByArtistId(artist.id));
  }

  addItems(List<int> items) async {
    var lastItem = await database.queueDao.getLastItem();
    var insertItems =
        items.map((id) => new QueueItem(null, id, lastItem.position++));
    database.queueDao.addItems(insertItems);
  }

  addSong(Song song) async {
    //kommt unten in die Warteliste
    QueueItem lastItem = await database.queueDao.getLastItem();
    database.queueDao
        .addItem(new QueueItem(null, song.id, lastItem.position++));
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
    var queueItem = await database.queueDao.getNextItem(_currentSong?.id ?? 0);
    if (queueItem == null) {
      return;
    }
    _currentSong = await database.songDao.findSongById(queueItem.songId);
    if (_currentSong == null) {
      return;
    }
    int result = await audioPlayer.play(_currentSong.uri, isLocal: true);
    if (result != 1) {
      await playNext();
    }
  }

  //warteschlange leer -> nächstes lied in "alle lieder"
  playPrevious() async {
    var queueItem =
        await database.queueDao.getPreviousItem(_currentSong?.id ?? 0);
    if (queueItem == null) {
      return;
    }
    _currentSong = await database.songDao.findSongById(queueItem.songId);
    if (_currentSong == null) {
      return;
    }
    int result = await audioPlayer.play(_currentSong.uri, isLocal: true);
    if (result != 1) {
      await playPrevious();
    }
  }
}
