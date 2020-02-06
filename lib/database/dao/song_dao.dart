import 'package:floor/floor.dart';

import '../model/song.dart';

@dao
abstract class SongDao {
  @Query('SELECT * FROM Song')
  Stream<List<Song>> findAllSongs();

  @Query('SELECT * FROM Song WHERE id = :id')
  Future<Song> findSongById(int id);

  @Query('SELECT * FROM Song WHERE artistId = :id')
  Future<List<Song>> findSongsByArtistId(int id);

  @Query('SELECT * FROM Song WHERE albumId = :id')
  Future<List<Song>> findSongsByAlbumId(int albumId);

  @insert
  Future<void> insertSong(Song song);

  @insert
  Future<List<int>> insertAllSongs(List<Song> song);
}