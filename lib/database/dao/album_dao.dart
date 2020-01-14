import 'package:floor/floor.dart';

import '../model/album.dart';

@dao
abstract class AlbumDao {
  @Query('SELECT * FROM Albums')
  Future<List<Album>> findAllAlbums();

  @Query('SELECT * FROM Albums WHERE id = :id')
  Future<Album> findAlbumById(int id);


  @Query('SELECT * FROM Albums WHERE name = :name')
  Future<Album> findAlbumByName(String name);

  @insert
  Future<void> insertAlbum(Album folder);
}