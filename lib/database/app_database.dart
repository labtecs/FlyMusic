import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/folder_dao.dart';
import 'dao/song_dao.dart';
import 'model/folder.dart';
import 'model/song.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [Song, Folder])
abstract class AppDatabase extends FloorDatabase {
  SongDao get songDao;

  FolderDao get folderDao;
}
