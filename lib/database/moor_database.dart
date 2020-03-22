import 'package:moor/moor.dart';

part 'moor_database.g.dart';

//flutter packages pub run build_runner watch
//TODO pagination
// This annotation tells the code generator which tables this DB works with
@UseMoor(tables: [
  Songs,
  Albums,
  Artists,
  Arts,
  QueueItems,
  Playlists,
  PlaylistItems
], daos: [
  SongDao,
  AlbumDao,
  ArtistDao,
  ArtDao,
  QueueItemDao,
  PlaylistDao,
  PlaylistItemDao
])
// _$AppDatabase is the name of the generated class
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  AppDatabase.connect(DatabaseConnection connection)
      : super.connect(connection);

  // Bump this when changing tables and columns.
  // Migrations will be covered in the next part.
  @override
  int get schemaVersion => 1;

  /* //TODO foreign key bug
  @override
  MigrationStrategy get migration => MigrationStrategy(
        // Runs after all the migrations but BEFORE any queries have a chance to execute
        beforeOpen: (details) {
          return this.customStatement('PRAGMA foreign_keys = ON');
        },
      );
      */
}

@UseDao(tables: [Songs])
class SongDao extends DatabaseAccessor<AppDatabase> with _$SongDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  SongDao(this.db) : super(db);

  Future insert(Insertable<Song> song) =>
      into(songs).insert(song, mode: InsertMode.insertOrIgnore);

  Future insertAll(List<Insertable<Song>> songList) => db.batch(
      (b) => b.insertAll(songs, songList, mode: InsertMode.insertOrIgnore));

  Stream<List<Song>> findAllSongs() => (select(songs)
        ..orderBy(
          ([
            // Primary sorting by due date
            (s) => OrderingTerm(expression: s.title, mode: OrderingMode.asc)
          ]),
        ))
      .watch();

  Future<Song> findSongById(int id) =>
      (select(songs)..where((s) => s.id.equals(id))).getSingle();

  Future<List<Song>> findSongsByArtist(Artist artist) =>
      (select(songs)..where((s) => s.artistName.equals(artist.name))).get();

  Future<List<Song>> findSongsByAlbum(Album album) =>
      (select(songs)..where((s) => s.albumName.equals(album.name))).get();

  Future<List<Song>> findSongIdsByAlbumId(int id) => select(songs).get();
}

@UseDao(tables: [Albums])
class AlbumDao extends DatabaseAccessor<AppDatabase> with _$AlbumDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  AlbumDao(this.db) : super(db);

  Future insert(Insertable<Album> album) =>
      into(albums).insert(album, mode: InsertMode.insertOrIgnore);

  Future updateAlbum(Album album) => update(albums).replace(album);

  Stream<List<Album>> findAllAlbums() => (select(albums)
        ..orderBy(
          ([
            // Primary sorting by due date
            (a) => OrderingTerm(expression: a.name, mode: OrderingMode.asc)
          ]),
        ))
      .watch();

  Future<Album> findAlbumByName(String name) =>
      (select(albums)..where((a) => a.name.equals(name))).getSingle();
}

@UseDao(tables: [Artists])
class ArtistDao extends DatabaseAccessor<AppDatabase> with _$ArtistDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  ArtistDao(this.db) : super(db);

  Future insert(Insertable<Artist> artist) =>
      into(artists).insert(artist, mode: InsertMode.insertOrIgnore);

  Stream<List<Artist>> findAllArtists() => (select(artists)
        ..orderBy(
          ([
            // Primary sorting by due date
            (a) => OrderingTerm(expression: a.name, mode: OrderingMode.asc)
          ]),
        ))
      .watch();

  Future<Artist> findArtistByName(String name) =>
      (select(artists)..where((a) => a.name.equals(name))).getSingle();
}

@UseDao(tables: [Arts])
class ArtDao extends DatabaseAccessor<AppDatabase> with _$ArtDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  ArtDao(this.db) : super(db);

  Future insert(Insertable<Art> art) =>
      into(arts).insert(art, mode: InsertMode.insertOrIgnore);

  Future<Art> findArtByCrc(String crc) =>
      (select(arts)..where((a) => a.crc.equals(crc))).getSingle();
}

@UseDao(tables: [QueueItems])
class QueueItemDao extends DatabaseAccessor<AppDatabase>
    with _$QueueItemDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  QueueItemDao(this.db) : super(db);

  Future<int> insert(Insertable<QueueItem> queueItem) =>
      into(queueItems).insert(queueItem, mode: InsertMode.insertOrIgnore);

  Future insertAll(List<Insertable<QueueItem>> queueItemList) => db.batch((b) =>
      b.insertAll(queueItems, queueItemList, mode: InsertMode.insertOrIgnore));

  Future deleteQueueItem(QueueItem queueItem) =>
      delete(queueItems).delete(queueItem);

  Stream<List<QueueItem>> findAllQueueItems() => (select(queueItems)
        ..orderBy(
          ([
            // Primary sorting by due date
            (a) => OrderingTerm(expression: a.position, mode: OrderingMode.asc)
          ]),
        ))
      .watch();

  Future<QueueItem> getNextItem(int currentPosition) => (select(queueItems)
        ..orderBy(
          ([
            // Primary sorting by due date
            (a) => OrderingTerm(expression: a.position, mode: OrderingMode.asc)
          ]),
        )
        ..where((q) => q.position.isBiggerThanValue(currentPosition))
        ..limit(1))
      .getSingle();

  Future<QueueItem> getPreviousItem(int currentPosition) => (select(queueItems)
        ..orderBy(
          ([
            // Primary sorting by due date
            (a) => OrderingTerm(expression: a.position, mode: OrderingMode.asc)
          ]),
        )
        ..where((q) => q.position.isSmallerThanValue(currentPosition))
        ..limit(1))
      .getSingle();

  Future<QueueItem> getLastItem() => (select(queueItems)
        ..orderBy(
          ([
            // Primary sorting by due date
            (a) => OrderingTerm(expression: a.position, mode: OrderingMode.desc)
          ]),
        )
        ..limit(1))
      .getSingle();

  Future<QueueItem> getLastItemManually() => (select(queueItems)
        ..orderBy(
          ([
            // Primary sorting by due date
            (a) => OrderingTerm(expression: a.position, mode: OrderingMode.desc)
          ]),
        )
        ..where((q) => q.isManuallyAdded)
        ..limit(1))
      .getSingle();

  Future<QueueItem> getAnyManuallyAddedItem() => (select(queueItems)
        ..where((q) => q.isManuallyAdded)
        ..limit(1))
      .getSingle();

  Future<void> moveItemsDownFrom(int startPosition) => customUpdate(
      'UPDATE queue_items SET position = (position + 1) WHERE position >= $startPosition');

  Future<void> clearQueue() => delete(queueItems).go();

  Future<void> clearNotManuallyQueue(int currentItemId) => (delete(queueItems)
        ..where((q) => q.isManuallyAdded.equals(false))
        ..where((q) => q.id.isNotIn([currentItemId])))
      .go();

  Stream<List<QueryRow>> getGroupedItems() => customSelectQuery(
          'SELECT *, 1 as header FROM queue_items where position IN (Select min(position) FROM queue_items WHERE is_manually_added = 0  UNION Select min(position) FROM queue_items WHERE is_manually_added = 1 LIMIT 2) group by is_manually_added UNION Select *, 0 as header FROM queue_items order by position asc, header desc')
      .watch();

  Stream<List<QueryRow>> getGroupedItems2() => customSelectQuery(
          'Select min(position) as position FROM queue_items WHERE is_manually_added = 0  UNION Select min(position) as position FROM queue_items WHERE is_manually_added = 1 LIMIT 2')
      .watch();

  findPlaylistName(int songId) {}

  getGroupedItemsAfterCurrent(int currentPosition) => customSelectQuery(
          'SELECT *, 1 as header FROM queue_items where position IN (Select min(position) FROM queue_items WHERE is_manually_added = 0  UNION Select min(position) FROM queue_items WHERE is_manually_added = 1 LIMIT 2) group by is_manually_added UNION Select *, 0 as header FROM queue_items WHERE position > $currentPosition order by position asc, header desc')
      .watch();
}

@UseDao(tables: [Playlists])
class PlaylistDao extends DatabaseAccessor<AppDatabase>
    with _$PlaylistDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  PlaylistDao(this.db) : super(db);

  Future insert(Insertable<Playlist> playlist) =>
      into(playlists).insert(playlist, mode: InsertMode.insertOrIgnore);

  Future<Playlist> findPlaylistById(int id) =>
      (select(playlists)..where((a) => a.id.equals(id))).getSingle();
}

@UseDao(tables: [PlaylistItems])
class PlaylistItemDao extends DatabaseAccessor<AppDatabase>
    with _$PlaylistItemDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  PlaylistItemDao(this.db) : super(db);

  Future insertAll(List<Insertable<PlaylistItem>> itemsList) => db.batch((b) =>
      b.insertAll(playlistItems, itemsList, mode: InsertMode.insertOrIgnore));

  Future<List<PlaylistItem>> findAllByPlaylist(int playlistId) =>
      (select(playlistItems)..where((q) => q.playlistId.equals(playlistId)))
          .get();
}

class Songs extends Table {
  @override
  Set<Column> get primaryKey => {id};

  //id foreign keys use less storage (smaller database)
  IntColumn get id => integer().autoIncrement()();

  TextColumn get path => text().withLength(min: 0).customConstraint('UNIQUE')();

  TextColumn get title => text().withLength(min: 0)();

  TextColumn get artist => text().withLength(min: 0)();

  IntColumn get duration => integer()();

  TextColumn get artCrc =>
      text().nullable().customConstraint('NULL REFERENCES arts(crc)')();

  TextColumn get albumName =>
      text().nullable().customConstraint('NOT NULL REFERENCES albums(name)')();

  TextColumn get artistName =>
      text().nullable().customConstraint('NOT NULL REFERENCES artists(name)')();
}

class Albums extends Table {
  @override
  Set<Column> get primaryKey => {name};

  //Album name ist unique, kommt nur einmal vor (deshalb primary key)
  TextColumn get name => text().withLength(min: 1)();

  IntColumn get playlistId =>
      integer().customConstraint('NOT NULL REFERENCES playlists(id)')();

  TextColumn get artCrc =>
      text().nullable().customConstraint('NULL REFERENCES arts(crc)')();
}

class Artists extends Table {
  @override
  Set<Column> get primaryKey => {name};

  //Artist name ist unique, kommt nur einmal vor (deshalb primary key)
  TextColumn get name => text().withLength(min: 1)();

  IntColumn get playlistId =>
      integer().customConstraint('NOT NULL REFERENCES playlists(id)')();
}

class Arts extends Table {
  @override
  Set<Column> get primaryKey => {crc};

  TextColumn get path => text().withLength(min: 1)();

  TextColumn get crc => text().withLength(min: 1)();
}

class QueueItems extends Table {
  @override
  Set<Column> get primaryKey => {id};

  IntColumn get id => integer().autoIncrement()();

  //.customConstraint('UNIQUE') would kill the update statement to move items
  IntColumn get position => integer()();

  BoolColumn get isManuallyAdded => boolean()();

  IntColumn get songId =>
      integer().customConstraint('NOT NULL REFERENCES songs(id)')();

  //where this song comes from
  IntColumn get playlistId =>
      integer().customConstraint('NOT NULL REFERENCES playlists(id)')();
}

class Playlists extends Table {
  IntColumn get id => integer().autoIncrement()();

  //kann geändert werden
  TextColumn get name => text().withLength(min: 1)();

  IntColumn get type =>
      integer()(); //-1: app (allsong, queue), 0: custom, 1: album, 2: artist
}

//relation zwischen playlist und song
class PlaylistItems extends Table {
  @override
  Set<Column> get primaryKey => {playlistId, songId};

  IntColumn get playlistId =>
      integer().customConstraint('NOT NULL REFERENCES playlists(id)')();

  IntColumn get songId =>
      integer().customConstraint('NOT NULL REFERENCES songs(id)')();
}
