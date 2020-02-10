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
    final database = _$AppDatabase();
    database.database = await database.open(
      name ?? ':memory:',
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

  Future<sqflite.Database> open(String name, List<Migration> migrations,
      [Callback callback]) async {
    final path = join(await sqflite.getDatabasesPath(), name);

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
            'CREATE TABLE IF NOT EXISTS `Song` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT, `artist` TEXT, `songArt` TEXT, `albumId` INTEGER, `duration` INTEGER, `uri` TEXT, `artistId` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Album` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `album_art` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Artist` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT)');

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
                  'songArt': item.songArt,
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
      row['songArt'] as String,
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
    return _queryAdapter.query('SELECT * FROM Song WHERE id = ?',
        arguments: <dynamic>[id], mapper: _songMapper);
  }

  @override
  Future<List<Song>> findSongsByArtistId(int id) async {
    return _queryAdapter.queryList('SELECT * FROM Song WHERE artistId = ?',
        arguments: <dynamic>[id], mapper: _songMapper);
  }

  @override
  Future<List<Song>> findSongsByAlbumId(int albumId) async {
    return _queryAdapter.queryList('SELECT * FROM Song WHERE albumId = ?',
        arguments: <dynamic>[albumId], mapper: _songMapper);
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
                  'album_art': item.albumArt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _albumMapper = (Map<String, dynamic> row) => Album(
      row['id'] as int, row['name'] as String, row['album_art'] as String);

  final InsertionAdapter<Album> _albumInsertionAdapter;

  @override
  Future<List<Album>> findAllAlbums() async {
    return _queryAdapter.queryList('SELECT * FROM Album', mapper: _albumMapper);
  }

  @override
  Future<Album> findAlbumById(int id) async {
    return _queryAdapter.query('SELECT * FROM Album WHERE id = ?',
        arguments: <dynamic>[id], mapper: _albumMapper);
  }

  @override
  Future<Album> findAlbumByName(String name) async {
    return _queryAdapter.query('SELECT * FROM Album WHERE name = ?',
        arguments: <dynamic>[name], mapper: _albumMapper);
  }

  @override
  Future<int> insertAlbum(Album folder) {
    return _albumInsertionAdapter.insertAndReturnId(
        folder, sqflite.ConflictAlgorithm.abort);
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
    return _queryAdapter.query('SELECT * FROM Artist WHERE name = ?',
        arguments: <dynamic>[name], mapper: _artistMapper);
  }

  @override
  Future<int> insertArtist(Artist artist) {
    return _artistInsertionAdapter.insertAndReturnId(
        artist, sqflite.ConflictAlgorithm.abort);
  }
}
