import 'dart:async';


import 'dao/folder_dao.dart';
import 'dao/song_dao.dart';
import 'model/folder.dart';
import 'model/song.dart';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [Song, Folder])
abstract class AppDatabase extends FloorDatabase {
  SongDao get songDao;
  FolderDao get folderDao;
}
