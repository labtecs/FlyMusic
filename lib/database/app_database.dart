import 'dart:async';

import 'package:floor/floor.dart';
import 'package:flymusic/database/dao/album_dao.dart';
import 'package:flymusic/database/dao/artist_dao.dart';
import 'package:flymusic/database/dao/song_dao.dart';
import 'package:flymusic/database/model/album.dart';
import 'package:flymusic/database/model/art.dart';
import 'package:flymusic/database/model/artist.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

//flutter packages pub run build_runner build
@Database(version: 1, entities: [Song, Album, Artist, Art])
abstract class AppDatabase extends FloorDatabase {
  SongDao get songDao;

  AlbumDao get albumDao;

  ArtistDao get artistDao;

  ArtDao get artDao;
}
