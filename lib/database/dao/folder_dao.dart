import 'package:floor/floor.dart';

import '../model/folder.dart';

@dao
abstract class FolderDao {
  @Query('SELECT * FROM Folders')
  Future<List<Folder>> findAllFolders();

  @Query('SELECT * FROM Folders WHERE id = :id')
  Future<Folder> findFolderById(int id);

  @insert
  Future<void> insertFolder(Folder folder);
}