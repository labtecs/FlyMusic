import 'package:floor/floor.dart';

import '../model/album.dart';

@dao
abstract class AlbumDao {
  @Query('SELECT * FROM Album')
  Future<List<Album>> findAllAlbums();

  @Query('SELECT * FROM Album WHERE id = :id')
  Future<Album> findAlbumById(int id);

  @Query('SELECT * FROM Album WHERE id = :id')
  // String<Album> findAlbumStringById(int id);

  @Query('SELECT * FROM Album WHERE name = :name')
  Future<Album> findAlbumByName(String name);

  @insert
  Future<void> insertAlbum(Album folder);
}