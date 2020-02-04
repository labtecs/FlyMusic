import 'package:flymusic/database/model/album.dart';
import 'package:flymusic/database/model/artist.dart';
import 'package:flymusic/database/model/song.dart';

class MusicQueue {
  static final MusicQueue _instance = MusicQueue._internal();

  factory MusicQueue() => _instance;

  MusicQueue._internal() {
// init things inside this
  }

  playAlbum(Album album){
    //play songs in this album
  }

  playArtist(Artist artist){
    //play songs in this album
  }

  playSong(Song song){

  }

  addSongToQueue(Song song){

  }

}
