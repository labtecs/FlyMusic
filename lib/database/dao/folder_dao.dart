import 'package:floor/floor.dart';

import '../model/album.dart';

@dao
abstract class FolderDao {
  @Query('SELECT * FROM Folders')
  Future<List<Album>> findAllFolders();

  @Query('SELECT * FROM Folders WHERE id = :id')
  Future<Album> findFolderById(int id);

  @insert
  Future<void> insertFolder(Album folder);
}