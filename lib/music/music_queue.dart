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
  Song currentSong;

  MusicQueue._internal() {
    audioPlayer.setReleaseMode(ReleaseMode.STOP);
  }

  playSong(Song song) async {
    //kommt oben in die warteschlange die anderen lieder werden nach unten verschoben
    await addSong(song);
    database.queueDao.moveItemsDownBy(0);
    database.queueDao.addItem(new QueueItem(null, song.id, 0));
    await playIfNotPlaying();
  }

  playAlbum(Album album) async{
    await clear();
    await _addAlbum(album);
    await playIfNotPlaying();
  }

  playArtist(Artist artist) async{
    await clear();
    await _addArtist(artist);
    await playIfNotPlaying();
  }

  addSong(Song song) async {
    //kommt unten in die Warteliste
    QueueItem lastItem = await database.queueDao.getLastItem();
    database.queueDao
        .addItem(new QueueItem(null, song.id, lastItem?.position++ ?? 0));
    await playIfNotPlaying();
  }

  addArtist(Artist artist) async {
    await _addArtist(artist);
    await playIfNotPlaying();
  }

  addAlbum(Album album) async {
    await _addAlbum(album);
    await playIfNotPlaying();
  }

  playIfNotPlaying() async{
    if (audioPlayer.state != AudioPlayerState.PLAYING) {
      await playPause();
    }
  }



  clear(){

  }

  _addAlbum(Album album) async {
    //alle lieder in die warteschlange (unten)
    _addItems((await database.songDao.findSongIdsByAlbumId(album.id))
        .map((item) => item.id).toList());
  }

  _addArtist(Artist artist) async {
    //alle lieder in die warteschlange (unten)
    _addItems((await database.songDao.findSongIdsByArtistId(artist.id))
        .map((item) => item.id).toList());
  }

  _addItems(List<int> items) async {
    var lastItem = await database.queueDao.getLastItem();
    var insertItems =
        items.map((id) => new QueueItem(null, id, lastItem?.position++ ?? 0));
    database.queueDao.addItems(insertItems);
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
    var queueItem = await database.queueDao.getNextItem(currentSong?.id ?? -1);
    if (queueItem == null) {
      return;
    }
    currentSong = await database.songDao.findSongById(queueItem.songId);
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
    var queueItem =
        await database.queueDao.getPreviousItem(currentSong?.id ?? 1);
    if (queueItem == null) {
      return;
    }
    currentSong = await database.songDao.findSongById(queueItem.songId);
    if (currentSong == null) {
      return;
    }
    int result = await audioPlayer.play(currentSong.uri, isLocal: true);
    if (result != 1) {
      await playPrevious();
    }
  }
}
