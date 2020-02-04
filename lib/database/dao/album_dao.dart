import 'package:floor/floor.dart';

import '../model/album.dart';

@dao
abstract class AlbumDao {
  @Query('SELECT * FROM Album')
  Future<List<Album>> findAllAlbums();

  @Query('SELECT * FROM Album WHERE id = :id LIMIT 1')
  Future<Album> findAlbumById(int id);


  @Query('SELECT * FROM Album WHERE name = :name LIMIT 1')
  Future<Album> findAlbumByName(String name);

  @insert
  Future<void> insertAlbum(Album folder);
}