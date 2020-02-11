import 'package:floor/floor.dart';

import 'package:flymusic/database/model/song.dart';

@dao
abstract class SongDao {

  @Query('SELECT * FROM Song')
  Stream<List<Song>> findAllSongs();

  @Query('SELECT * FROM Song WHERE id = :id LIMIT 1')
  Future<Song> findSongById(int id);

  @Query('SELECT * FROM Song WHERE artistId = :id')
  Future<List<Song>> findSongsByArtistId(int id);

  @Query('SELECT id FROM Song WHERE artistId = :id')
  Future<List<Song>> findSongIdsByArtistId(int id);

  @Query('SELECT * FROM Song WHERE albumId = :id')
  Future<List<Song>> findSongsByAlbumId(int id);

  @Query('SELECT id FROM Song WHERE albumId = :id')
  Future<List<Song>> findSongIdsByAlbumId(int id);

  @insert
  Future<void> insertSong(Song song);

  @insert
  Future<List<int>> insertAllSongs(List<Song> song);

}