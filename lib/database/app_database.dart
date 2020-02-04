import 'dart:async';


import 'package:flymusic/database/model/artist.dart';

import 'dao/album_dao.dart';
import 'dao/artist_dao.dart';
import 'dao/queue_dao.dart';
import 'dao/song_dao.dart';
import 'model/album.dart';
import 'model/queue_item.dart';
import 'model/song.dart';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';
//flutter packages pub run build_runner build
@Database(version: 1, entities: [Song, Album, Artist, QueueItem])
abstract class AppDatabase extends FloorDatabase {
  SongDao get songDao;
  AlbumDao get albumDao;
  ArtistDao get artistDao;
  QueueDao get queueDao;
}
