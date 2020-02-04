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

  @Query('SELECT id FROM Song WHERE artistId = :id')
  Future<List<int>> findSongIdsByArtistId(int id);

  @Query('SELECT * FROM Song WHERE albumId = :id')
  Future<List<Song>> findSongsByAlbumId(int albumId);

  @Query('SELECT id FROM Song WHERE albumId = :id')
  Future<List<int>> findSongIdsByAlbumId(int albumId);

  @insert
  Future<void> insertSong(Song song);

  @insert
  Future<List<int>> insertAllSongs(List<Song> song);
}