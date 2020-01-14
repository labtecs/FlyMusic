import 'package:floor/floor.dart';

import '../model/song.dart';

@dao
abstract class SongDao {
  @Query('SELECT * FROM Songs')
  Future<List<Song>> findAllSongs();

  @Query('SELECT * FROM Songs WHERE id = :id')
  Future<Song> findSongById(int id);

  @insert
  Future<void> insertSong(Song song);

  @insert
  Future<void> insertAllSongs(List<Song> song);
}