import 'package:floor/floor.dart';

import '../model/song.dart';

@dao
abstract class SongDao {
  @Query('SELECT * FROM Song')
  Future<List<Song>> findAllSongs();

  @Query('SELECT * FROM Song WHERE id = :id')
  Future<Song> findSongById(int id);

  @insert
  Future<void> insertSong(Song song);

  @insert
  Future<List<int>> insertAllSongs(List<Song> song);
}