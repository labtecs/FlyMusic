// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? join(await sqflite.getDatabasesPath(), name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SongDao _songDaoInstance;

  AlbumDao _albumDaoInstance;

  ArtistDao _artistDaoInstance;

  ArtDao _artDaoInstance;

  QueueDao _queueDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Song` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT, `artist` TEXT, `artId` INTEGER, `albumId` INTEGER, `duration` INTEGER, `uri` TEXT, `artistId` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Album` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `artId` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Artist` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Queue` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `songId` INTEGER, `position` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Art` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `path` TEXT, `crc` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  SongDao get songDao {
    return _songDaoInstance ??= _$SongDao(database, changeListener);
  }

  @override
  AlbumDao get albumDao {
    return _albumDaoInstance ??= _$AlbumDao(database, changeListener);
  }

  @override
  ArtistDao get artistDao {
    return _artistDaoInstance ??= _$ArtistDao(database, changeListener);
  }

  @override
  ArtDao get artDao {
    return _artDaoInstance ??= _$ArtDao(database, changeListener);
  }

  @override
  QueueDao get queueDao {
    return _queueDaoInstance ??= _$QueueDao(database, changeListener);
  }
}

class _$SongDao extends SongDao {
  _$SongDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _songInsertionAdapter = InsertionAdapter(
            database,
            'Song',
            (Song item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'artist': item.artist,
                  'artId': item.artId,
                  'albumId': item.albumId,
                  'duration': item.duration,
                  'uri': item.uri,
                  'artistId': item.artistId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _songMapper = (Map<String, dynamic> row) => Song(
      row['id'] as int,
      row['title'] as String,
      row['artist'] as String,
      row['artId'] as int,
      row['albumId'] as int,
      row['duration'] as int,
      row['uri'] as String,
      row['artistId'] as int);

  final InsertionAdapter<Song> _songInsertionAdapter;

  @override
  Stream<List<Song>> findAllSongs() {
    return _queryAdapter.queryListStream('SELECT * FROM Song',
        tableName: 'Song', mapper: _songMapper);
  }

  @override
  Future<Song> findSongById(int id) async {
    return _queryAdapter.query('SELECT * FROM Song WHERE id = ? LIMIT 1',
        arguments: <dynamic>[id], mapper: _songMapper);
  }

  @override
  Future<List<Song>> findSongsByArtistId(int id) async {
    return _queryAdapter.queryList('SELECT * FROM Song WHERE artistId = ?',
        arguments: <dynamic>[id], mapper: _songMapper);
  }

  @override
  Future<List<Song>> findSongIdsByArtistId(int id) async {
    return _queryAdapter.queryList('SELECT id FROM Song WHERE artistId = ?',
        arguments: <dynamic>[id], mapper: _songMapper);
  }

  @override
  Future<List<Song>> findSongsByAlbumId(int id) async {
    return _queryAdapter.queryList('SELECT * FROM Song WHERE albumId = ?',
        arguments: <dynamic>[id], mapper: _songMapper);
  }

  @override
  Future<List<Song>> findSongIdsByAlbumId(int id) async {
    return _queryAdapter.queryList('SELECT id FROM Song WHERE albumId = ?',
        arguments: <dynamic>[id], mapper: _songMapper);
  }

  @override
  Future<void> insertSong(Song song) async {
    await _songInsertionAdapter.insert(song, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<List<int>> insertAllSongs(List<Song> song) {
    return _songInsertionAdapter.insertListAndReturnIds(
        song, sqflite.ConflictAlgorithm.abort);
  }
}

class _$AlbumDao extends AlbumDao {
  _$AlbumDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _albumInsertionAdapter = InsertionAdapter(
            database,
            'Album',
            (Album item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'artId': item.artId
                }),
        _albumUpdateAdapter = UpdateAdapter(
            database,
            'Album',
            ['id'],
            (Album item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'artId': item.artId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _albumMapper = (Map<String, dynamic> row) =>
      Album(row['id'] as int, row['name'] as String, row['artId'] as int);

  final InsertionAdapter<Album> _albumInsertionAdapter;

  final UpdateAdapter<Album> _albumUpdateAdapter;

  @override
  Future<List<Album>> findAllAlbums() async {
    return _queryAdapter.queryList('SELECT * FROM Album', mapper: _albumMapper);
  }

  @override
  Future<Album> findAlbumById(int id) async {
    return _queryAdapter.query('SELECT * FROM Album WHERE id = ? LIMIT 1',
        arguments: <dynamic>[id], mapper: _albumMapper);
  }

  @override
  Future<Album> findAlbumByName(String name) async {
    return _queryAdapter.query('SELECT * FROM Album WHERE name = ? LIMIT 1',
        arguments: <dynamic>[name], mapper: _albumMapper);
  }

  @override
  Future<int> insertAlbum(Album folder) {
    return _albumInsertionAdapter.insertAndReturnId(
        folder, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> updateAlbum(Album folder) async {
    await _albumUpdateAdapter.update(folder, sqflite.ConflictAlgorithm.abort);
  }
}

class _$ArtistDao extends ArtistDao {
  _$ArtistDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _artistInsertionAdapter = InsertionAdapter(
            database,
            'Artist',
            (Artist item) =>
                <String, dynamic>{'id': item.id, 'name': item.name},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _artistMapper = (Map<String, dynamic> row) =>
      Artist(row['id'] as int, row['name'] as String);

  final InsertionAdapter<Artist> _artistInsertionAdapter;

  @override
  Stream<List<Artist>> findAllArtists() {
    return _queryAdapter.queryListStream('SELECT * FROM Artist',
        tableName: 'Artist', mapper: _artistMapper);
  }

  @override
  Future<Artist> findArtistByName(String name) async {
    return _queryAdapter.query('SELECT * FROM Artist WHERE name = ? LIMIT 1',
        arguments: <dynamic>[name], mapper: _artistMapper);
  }

  @override
  Future<int> insertArtist(Artist artist) {
    return _artistInsertionAdapter.insertAndReturnId(
        artist, sqflite.ConflictAlgorithm.abort);
  }
}

class _$ArtDao extends ArtDao {
  _$ArtDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _artInsertionAdapter = InsertionAdapter(
            database,
            'Art',
            (Art item) => <String, dynamic>{
                  'id': item.id,
                  'path': item.path,
                  'crc': item.crc
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _artMapper = (Map<String, dynamic> row) =>
      Art(row['id'] as int, row['path'] as String, row['crc'] as String);

  final InsertionAdapter<Art> _artInsertionAdapter;

  @override
  Future<Art> findArtById(int id) async {
    return _queryAdapter.query('SELECT * FROM Art WHERE id = ? LIMIT 1',
        arguments: <dynamic>[id], mapper: _artMapper);
  }

  @override
  Future<Art> findArtByCrc(String crc) async {
    return _queryAdapter.query('SELECT * FROM Art WHERE crc = ? LIMIT 1',
        arguments: <dynamic>[crc], mapper: _artMapper);
  }

  @override
  Future<int> insertArt(Art art) {
    return _artInsertionAdapter.insertAndReturnId(
        art, sqflite.ConflictAlgorithm.abort);
  }
}

class _$QueueDao extends QueueDao {
  _$QueueDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _queueItemInsertionAdapter = InsertionAdapter(
            database,
            'Queue',
            (QueueItem item) => <String, dynamic>{
                  'id': item.id,
                  'songId': item.songId,
                  'position': item.position
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _queueMapper = (Map<String, dynamic> row) =>
      QueueItem(row['id'] as int, row['songId'] as int, row['position'] as int);

  final InsertionAdapter<QueueItem> _queueItemInsertionAdapter;

  @override
  Stream<List<QueueItem>> findAllItems() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Queue ORDER BY position ASC',
        tableName: 'Queue',
        mapper: _queueMapper);
  }

  @override
  Future<QueueItem> getNextItem(int currentPosition) async {
    return _queryAdapter.query(
        'SELECT * FROM Queue WHERE position > ? ORDER BY position DESC LIMIT 1',
        arguments: <dynamic>[currentPosition],
        mapper: _queueMapper);
  }

  @override
  Future<QueueItem> getPreviousItem(int currentPosition) async {
    return _queryAdapter.query(
        'SELECT * FROM Queue WHERE position < ? ORDER BY position ASC LIMIT 1',
        arguments: <dynamic>[currentPosition],
        mapper: _queueMapper);
  }

  @override
  Future<QueueItem> getLastItem() async {
    return _queryAdapter.query(
        'SELECT * FROM Queue ORDER BY position DESC LIMIT 1',
        mapper: _queueMapper);
  }

  @override
  Future<void> moveItemsDownBy(int move) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Queue SET position = position + ?',
        arguments: <dynamic>[move]);
  }

  @override
  Future<void> addItem(QueueItem item) async {
    await _queueItemInsertionAdapter.insert(
        item, sqflite.ConflictAlgorithm.abort);
  }

  @override
  Future<void> addItems(List<QueueItem> items) async {
    await _queueItemInsertionAdapter.insertList(
        items, sqflite.ConflictAlgorithm.abort);
  }
}
