// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Song extends DataClass implements Insertable<Song> {
  final int id;
  final String title;
  final String artist;
  final String uri;
  final int duration;
  final String artCrc;
  final String albumName;
  final String artistName;
  Song(
      {@required this.id,
      @required this.title,
      @required this.artist,
      @required this.uri,
      @required this.duration,
      this.artCrc,
      this.albumName,
      this.artistName});
  factory Song.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Song(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      artist:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}artist']),
      uri: stringType.mapFromDatabaseResponse(data['${effectivePrefix}uri']),
      duration:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}duration']),
      artCrc:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}art_crc']),
      albumName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}album_name']),
      artistName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}artist_name']),
    );
  }
  factory Song.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Song(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      artist: serializer.fromJson<String>(json['artist']),
      uri: serializer.fromJson<String>(json['uri']),
      duration: serializer.fromJson<int>(json['duration']),
      artCrc: serializer.fromJson<String>(json['artCrc']),
      albumName: serializer.fromJson<String>(json['albumName']),
      artistName: serializer.fromJson<String>(json['artistName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'artist': serializer.toJson<String>(artist),
      'uri': serializer.toJson<String>(uri),
      'duration': serializer.toJson<int>(duration),
      'artCrc': serializer.toJson<String>(artCrc),
      'albumName': serializer.toJson<String>(albumName),
      'artistName': serializer.toJson<String>(artistName),
    };
  }

  @override
  SongsCompanion createCompanion(bool nullToAbsent) {
    return SongsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      artist:
          artist == null && nullToAbsent ? const Value.absent() : Value(artist),
      uri: uri == null && nullToAbsent ? const Value.absent() : Value(uri),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      artCrc:
          artCrc == null && nullToAbsent ? const Value.absent() : Value(artCrc),
      albumName: albumName == null && nullToAbsent
          ? const Value.absent()
          : Value(albumName),
      artistName: artistName == null && nullToAbsent
          ? const Value.absent()
          : Value(artistName),
    );
  }

  Song copyWith(
          {int id,
          String title,
          String artist,
          String uri,
          int duration,
          String artCrc,
          String albumName,
          String artistName}) =>
      Song(
        id: id ?? this.id,
        title: title ?? this.title,
        artist: artist ?? this.artist,
        uri: uri ?? this.uri,
        duration: duration ?? this.duration,
        artCrc: artCrc ?? this.artCrc,
        albumName: albumName ?? this.albumName,
        artistName: artistName ?? this.artistName,
      );
  @override
  String toString() {
    return (StringBuffer('Song(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('uri: $uri, ')
          ..write('duration: $duration, ')
          ..write('artCrc: $artCrc, ')
          ..write('albumName: $albumName, ')
          ..write('artistName: $artistName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          title.hashCode,
          $mrjc(
              artist.hashCode,
              $mrjc(
                  uri.hashCode,
                  $mrjc(
                      duration.hashCode,
                      $mrjc(artCrc.hashCode,
                          $mrjc(albumName.hashCode, artistName.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Song &&
          other.id == this.id &&
          other.title == this.title &&
          other.artist == this.artist &&
          other.uri == this.uri &&
          other.duration == this.duration &&
          other.artCrc == this.artCrc &&
          other.albumName == this.albumName &&
          other.artistName == this.artistName);
}

class SongsCompanion extends UpdateCompanion<Song> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> artist;
  final Value<String> uri;
  final Value<int> duration;
  final Value<String> artCrc;
  final Value<String> albumName;
  final Value<String> artistName;
  const SongsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.uri = const Value.absent(),
    this.duration = const Value.absent(),
    this.artCrc = const Value.absent(),
    this.albumName = const Value.absent(),
    this.artistName = const Value.absent(),
  });
  SongsCompanion.insert({
    this.id = const Value.absent(),
    @required String title,
    @required String artist,
    @required String uri,
    @required int duration,
    this.artCrc = const Value.absent(),
    this.albumName = const Value.absent(),
    this.artistName = const Value.absent(),
  })  : title = Value(title),
        artist = Value(artist),
        uri = Value(uri),
        duration = Value(duration);
  SongsCompanion copyWith(
      {Value<int> id,
      Value<String> title,
      Value<String> artist,
      Value<String> uri,
      Value<int> duration,
      Value<String> artCrc,
      Value<String> albumName,
      Value<String> artistName}) {
    return SongsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      uri: uri ?? this.uri,
      duration: duration ?? this.duration,
      artCrc: artCrc ?? this.artCrc,
      albumName: albumName ?? this.albumName,
      artistName: artistName ?? this.artistName,
    );
  }
}

class $SongsTable extends Songs with TableInfo<$SongsTable, Song> {
  final GeneratedDatabase _db;
  final String _alias;
  $SongsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn('title', $tableName, false, minTextLength: 0);
  }

  final VerificationMeta _artistMeta = const VerificationMeta('artist');
  GeneratedTextColumn _artist;
  @override
  GeneratedTextColumn get artist => _artist ??= _constructArtist();
  GeneratedTextColumn _constructArtist() {
    return GeneratedTextColumn('artist', $tableName, false, minTextLength: 0);
  }

  final VerificationMeta _uriMeta = const VerificationMeta('uri');
  GeneratedTextColumn _uri;
  @override
  GeneratedTextColumn get uri => _uri ??= _constructUri();
  GeneratedTextColumn _constructUri() {
    return GeneratedTextColumn('uri', $tableName, false, minTextLength: 0);
  }

  final VerificationMeta _durationMeta = const VerificationMeta('duration');
  GeneratedIntColumn _duration;
  @override
  GeneratedIntColumn get duration => _duration ??= _constructDuration();
  GeneratedIntColumn _constructDuration() {
    return GeneratedIntColumn(
      'duration',
      $tableName,
      false,
    );
  }

  final VerificationMeta _artCrcMeta = const VerificationMeta('artCrc');
  GeneratedTextColumn _artCrc;
  @override
  GeneratedTextColumn get artCrc => _artCrc ??= _constructArtCrc();
  GeneratedTextColumn _constructArtCrc() {
    return GeneratedTextColumn('art_crc', $tableName, true,
        $customConstraints: 'NULL REFERENCES Art(crc)');
  }

  final VerificationMeta _albumNameMeta = const VerificationMeta('albumName');
  GeneratedTextColumn _albumName;
  @override
  GeneratedTextColumn get albumName => _albumName ??= _constructAlbumName();
  GeneratedTextColumn _constructAlbumName() {
    return GeneratedTextColumn('album_name', $tableName, true,
        $customConstraints: 'NULL REFERENCES Album(name)');
  }

  final VerificationMeta _artistNameMeta = const VerificationMeta('artistName');
  GeneratedTextColumn _artistName;
  @override
  GeneratedTextColumn get artistName => _artistName ??= _constructArtistName();
  GeneratedTextColumn _constructArtistName() {
    return GeneratedTextColumn('artist_name', $tableName, true,
        $customConstraints: 'NULL REFERENCES Artist(name)');
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, title, artist, uri, duration, artCrc, albumName, artistName];
  @override
  $SongsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'songs';
  @override
  final String actualTableName = 'songs';
  @override
  VerificationContext validateIntegrity(SongsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.title.present) {
      context.handle(
          _titleMeta, title.isAcceptableValue(d.title.value, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (d.artist.present) {
      context.handle(
          _artistMeta, artist.isAcceptableValue(d.artist.value, _artistMeta));
    } else if (isInserting) {
      context.missing(_artistMeta);
    }
    if (d.uri.present) {
      context.handle(_uriMeta, uri.isAcceptableValue(d.uri.value, _uriMeta));
    } else if (isInserting) {
      context.missing(_uriMeta);
    }
    if (d.duration.present) {
      context.handle(_durationMeta,
          duration.isAcceptableValue(d.duration.value, _durationMeta));
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (d.artCrc.present) {
      context.handle(
          _artCrcMeta, artCrc.isAcceptableValue(d.artCrc.value, _artCrcMeta));
    }
    if (d.albumName.present) {
      context.handle(_albumNameMeta,
          albumName.isAcceptableValue(d.albumName.value, _albumNameMeta));
    }
    if (d.artistName.present) {
      context.handle(_artistNameMeta,
          artistName.isAcceptableValue(d.artistName.value, _artistNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Song map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Song.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(SongsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.title.present) {
      map['title'] = Variable<String, StringType>(d.title.value);
    }
    if (d.artist.present) {
      map['artist'] = Variable<String, StringType>(d.artist.value);
    }
    if (d.uri.present) {
      map['uri'] = Variable<String, StringType>(d.uri.value);
    }
    if (d.duration.present) {
      map['duration'] = Variable<int, IntType>(d.duration.value);
    }
    if (d.artCrc.present) {
      map['art_crc'] = Variable<String, StringType>(d.artCrc.value);
    }
    if (d.albumName.present) {
      map['album_name'] = Variable<String, StringType>(d.albumName.value);
    }
    if (d.artistName.present) {
      map['artist_name'] = Variable<String, StringType>(d.artistName.value);
    }
    return map;
  }

  @override
  $SongsTable createAlias(String alias) {
    return $SongsTable(_db, alias);
  }
}

class Album extends DataClass implements Insertable<Album> {
  final String name;
  final String artCrc;
  Album({@required this.name, this.artCrc});
  factory Album.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return Album(
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      artCrc:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}art_crc']),
    );
  }
  factory Album.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Album(
      name: serializer.fromJson<String>(json['name']),
      artCrc: serializer.fromJson<String>(json['artCrc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'artCrc': serializer.toJson<String>(artCrc),
    };
  }

  @override
  AlbumsCompanion createCompanion(bool nullToAbsent) {
    return AlbumsCompanion(
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      artCrc:
          artCrc == null && nullToAbsent ? const Value.absent() : Value(artCrc),
    );
  }

  Album copyWith({String name, String artCrc}) => Album(
        name: name ?? this.name,
        artCrc: artCrc ?? this.artCrc,
      );
  @override
  String toString() {
    return (StringBuffer('Album(')
          ..write('name: $name, ')
          ..write('artCrc: $artCrc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(name.hashCode, artCrc.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Album &&
          other.name == this.name &&
          other.artCrc == this.artCrc);
}

class AlbumsCompanion extends UpdateCompanion<Album> {
  final Value<String> name;
  final Value<String> artCrc;
  const AlbumsCompanion({
    this.name = const Value.absent(),
    this.artCrc = const Value.absent(),
  });
  AlbumsCompanion.insert({
    @required String name,
    this.artCrc = const Value.absent(),
  }) : name = Value(name);
  AlbumsCompanion copyWith({Value<String> name, Value<String> artCrc}) {
    return AlbumsCompanion(
      name: name ?? this.name,
      artCrc: artCrc ?? this.artCrc,
    );
  }
}

class $AlbumsTable extends Albums with TableInfo<$AlbumsTable, Album> {
  final GeneratedDatabase _db;
  final String _alias;
  $AlbumsTable(this._db, [this._alias]);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false, minTextLength: 1);
  }

  final VerificationMeta _artCrcMeta = const VerificationMeta('artCrc');
  GeneratedTextColumn _artCrc;
  @override
  GeneratedTextColumn get artCrc => _artCrc ??= _constructArtCrc();
  GeneratedTextColumn _constructArtCrc() {
    return GeneratedTextColumn('art_crc', $tableName, true,
        $customConstraints: 'NULL REFERENCES Art(crc)');
  }

  @override
  List<GeneratedColumn> get $columns => [name, artCrc];
  @override
  $AlbumsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'albums';
  @override
  final String actualTableName = 'albums';
  @override
  VerificationContext validateIntegrity(AlbumsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (d.artCrc.present) {
      context.handle(
          _artCrcMeta, artCrc.isAcceptableValue(d.artCrc.value, _artCrcMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  Album map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Album.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(AlbumsCompanion d) {
    final map = <String, Variable>{};
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.artCrc.present) {
      map['art_crc'] = Variable<String, StringType>(d.artCrc.value);
    }
    return map;
  }

  @override
  $AlbumsTable createAlias(String alias) {
    return $AlbumsTable(_db, alias);
  }
}

class Artist extends DataClass implements Insertable<Artist> {
  final String name;
  Artist({@required this.name});
  factory Artist.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return Artist(
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  factory Artist.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Artist(
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
    };
  }

  @override
  ArtistsCompanion createCompanion(bool nullToAbsent) {
    return ArtistsCompanion(
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  Artist copyWith({String name}) => Artist(
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Artist(')..write('name: $name')..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(name.hashCode);
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) || (other is Artist && other.name == this.name);
}

class ArtistsCompanion extends UpdateCompanion<Artist> {
  final Value<String> name;
  const ArtistsCompanion({
    this.name = const Value.absent(),
  });
  ArtistsCompanion.insert({
    @required String name,
  }) : name = Value(name);
  ArtistsCompanion copyWith({Value<String> name}) {
    return ArtistsCompanion(
      name: name ?? this.name,
    );
  }
}

class $ArtistsTable extends Artists with TableInfo<$ArtistsTable, Artist> {
  final GeneratedDatabase _db;
  final String _alias;
  $ArtistsTable(this._db, [this._alias]);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false, minTextLength: 1);
  }

  @override
  List<GeneratedColumn> get $columns => [name];
  @override
  $ArtistsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'artists';
  @override
  final String actualTableName = 'artists';
  @override
  VerificationContext validateIntegrity(ArtistsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  Artist map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Artist.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ArtistsCompanion d) {
    final map = <String, Variable>{};
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    return map;
  }

  @override
  $ArtistsTable createAlias(String alias) {
    return $ArtistsTable(_db, alias);
  }
}

class Art extends DataClass implements Insertable<Art> {
  final String path;
  final String crc;
  Art({@required this.path, @required this.crc});
  factory Art.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return Art(
      path: stringType.mapFromDatabaseResponse(data['${effectivePrefix}path']),
      crc: stringType.mapFromDatabaseResponse(data['${effectivePrefix}crc']),
    );
  }
  factory Art.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Art(
      path: serializer.fromJson<String>(json['path']),
      crc: serializer.fromJson<String>(json['crc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'path': serializer.toJson<String>(path),
      'crc': serializer.toJson<String>(crc),
    };
  }

  @override
  ArtsCompanion createCompanion(bool nullToAbsent) {
    return ArtsCompanion(
      path: path == null && nullToAbsent ? const Value.absent() : Value(path),
      crc: crc == null && nullToAbsent ? const Value.absent() : Value(crc),
    );
  }

  Art copyWith({String path, String crc}) => Art(
        path: path ?? this.path,
        crc: crc ?? this.crc,
      );
  @override
  String toString() {
    return (StringBuffer('Art(')
          ..write('path: $path, ')
          ..write('crc: $crc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(path.hashCode, crc.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Art && other.path == this.path && other.crc == this.crc);
}

class ArtsCompanion extends UpdateCompanion<Art> {
  final Value<String> path;
  final Value<String> crc;
  const ArtsCompanion({
    this.path = const Value.absent(),
    this.crc = const Value.absent(),
  });
  ArtsCompanion.insert({
    @required String path,
    @required String crc,
  })  : path = Value(path),
        crc = Value(crc);
  ArtsCompanion copyWith({Value<String> path, Value<String> crc}) {
    return ArtsCompanion(
      path: path ?? this.path,
      crc: crc ?? this.crc,
    );
  }
}

class $ArtsTable extends Arts with TableInfo<$ArtsTable, Art> {
  final GeneratedDatabase _db;
  final String _alias;
  $ArtsTable(this._db, [this._alias]);
  final VerificationMeta _pathMeta = const VerificationMeta('path');
  GeneratedTextColumn _path;
  @override
  GeneratedTextColumn get path => _path ??= _constructPath();
  GeneratedTextColumn _constructPath() {
    return GeneratedTextColumn('path', $tableName, false, minTextLength: 1);
  }

  final VerificationMeta _crcMeta = const VerificationMeta('crc');
  GeneratedTextColumn _crc;
  @override
  GeneratedTextColumn get crc => _crc ??= _constructCrc();
  GeneratedTextColumn _constructCrc() {
    return GeneratedTextColumn('crc', $tableName, false, minTextLength: 1);
  }

  @override
  List<GeneratedColumn> get $columns => [path, crc];
  @override
  $ArtsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'arts';
  @override
  final String actualTableName = 'arts';
  @override
  VerificationContext validateIntegrity(ArtsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.path.present) {
      context.handle(
          _pathMeta, path.isAcceptableValue(d.path.value, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (d.crc.present) {
      context.handle(_crcMeta, crc.isAcceptableValue(d.crc.value, _crcMeta));
    } else if (isInserting) {
      context.missing(_crcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {crc};
  @override
  Art map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Art.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ArtsCompanion d) {
    final map = <String, Variable>{};
    if (d.path.present) {
      map['path'] = Variable<String, StringType>(d.path.value);
    }
    if (d.crc.present) {
      map['crc'] = Variable<String, StringType>(d.crc.value);
    }
    return map;
  }

  @override
  $ArtsTable createAlias(String alias) {
    return $ArtsTable(_db, alias);
  }
}

class QueueItem extends DataClass implements Insertable<QueueItem> {
  final int id;
  final int position;
  final int songId;
  QueueItem({@required this.id, @required this.position, this.songId});
  factory QueueItem.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return QueueItem(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      position:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}position']),
      songId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}song_id']),
    );
  }
  factory QueueItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return QueueItem(
      id: serializer.fromJson<int>(json['id']),
      position: serializer.fromJson<int>(json['position']),
      songId: serializer.fromJson<int>(json['songId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'position': serializer.toJson<int>(position),
      'songId': serializer.toJson<int>(songId),
    };
  }

  @override
  QueueItemsCompanion createCompanion(bool nullToAbsent) {
    return QueueItemsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      position: position == null && nullToAbsent
          ? const Value.absent()
          : Value(position),
      songId:
          songId == null && nullToAbsent ? const Value.absent() : Value(songId),
    );
  }

  QueueItem copyWith({int id, int position, int songId}) => QueueItem(
        id: id ?? this.id,
        position: position ?? this.position,
        songId: songId ?? this.songId,
      );
  @override
  String toString() {
    return (StringBuffer('QueueItem(')
          ..write('id: $id, ')
          ..write('position: $position, ')
          ..write('songId: $songId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(position.hashCode, songId.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is QueueItem &&
          other.id == this.id &&
          other.position == this.position &&
          other.songId == this.songId);
}

class QueueItemsCompanion extends UpdateCompanion<QueueItem> {
  final Value<int> id;
  final Value<int> position;
  final Value<int> songId;
  const QueueItemsCompanion({
    this.id = const Value.absent(),
    this.position = const Value.absent(),
    this.songId = const Value.absent(),
  });
  QueueItemsCompanion.insert({
    this.id = const Value.absent(),
    @required int position,
    this.songId = const Value.absent(),
  }) : position = Value(position);
  QueueItemsCompanion copyWith(
      {Value<int> id, Value<int> position, Value<int> songId}) {
    return QueueItemsCompanion(
      id: id ?? this.id,
      position: position ?? this.position,
      songId: songId ?? this.songId,
    );
  }
}

class $QueueItemsTable extends QueueItems
    with TableInfo<$QueueItemsTable, QueueItem> {
  final GeneratedDatabase _db;
  final String _alias;
  $QueueItemsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _positionMeta = const VerificationMeta('position');
  GeneratedIntColumn _position;
  @override
  GeneratedIntColumn get position => _position ??= _constructPosition();
  GeneratedIntColumn _constructPosition() {
    return GeneratedIntColumn(
      'position',
      $tableName,
      false,
    );
  }

  final VerificationMeta _songIdMeta = const VerificationMeta('songId');
  GeneratedIntColumn _songId;
  @override
  GeneratedIntColumn get songId => _songId ??= _constructSongId();
  GeneratedIntColumn _constructSongId() {
    return GeneratedIntColumn('song_id', $tableName, true,
        $customConstraints: 'NULL REFERENCES Song(id)');
  }

  @override
  List<GeneratedColumn> get $columns => [id, position, songId];
  @override
  $QueueItemsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'queue_items';
  @override
  final String actualTableName = 'queue_items';
  @override
  VerificationContext validateIntegrity(QueueItemsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.position.present) {
      context.handle(_positionMeta,
          position.isAcceptableValue(d.position.value, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (d.songId.present) {
      context.handle(
          _songIdMeta, songId.isAcceptableValue(d.songId.value, _songIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QueueItem map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return QueueItem.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(QueueItemsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.position.present) {
      map['position'] = Variable<int, IntType>(d.position.value);
    }
    if (d.songId.present) {
      map['song_id'] = Variable<int, IntType>(d.songId.value);
    }
    return map;
  }

  @override
  $QueueItemsTable createAlias(String alias) {
    return $QueueItemsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  _$AppDatabase.connect(DatabaseConnection c) : super.connect(c);
  $SongsTable _songs;
  $SongsTable get songs => _songs ??= $SongsTable(this);
  $AlbumsTable _albums;
  $AlbumsTable get albums => _albums ??= $AlbumsTable(this);
  $ArtistsTable _artists;
  $ArtistsTable get artists => _artists ??= $ArtistsTable(this);
  $ArtsTable _arts;
  $ArtsTable get arts => _arts ??= $ArtsTable(this);
  $QueueItemsTable _queueItems;
  $QueueItemsTable get queueItems => _queueItems ??= $QueueItemsTable(this);
  SongDao _songDao;
  SongDao get songDao => _songDao ??= SongDao(this as AppDatabase);
  AlbumDao _albumDao;
  AlbumDao get albumDao => _albumDao ??= AlbumDao(this as AppDatabase);
  ArtistDao _artistDao;
  ArtistDao get artistDao => _artistDao ??= ArtistDao(this as AppDatabase);
  ArtDao _artDao;
  ArtDao get artDao => _artDao ??= ArtDao(this as AppDatabase);
  QueueItemDao _queueItemDao;
  QueueItemDao get queueItemDao =>
      _queueItemDao ??= QueueItemDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [songs, albums, artists, arts, queueItems];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$SongDaoMixin on DatabaseAccessor<AppDatabase> {
  $SongsTable get songs => db.songs;
}
mixin _$AlbumDaoMixin on DatabaseAccessor<AppDatabase> {
  $AlbumsTable get albums => db.albums;
}
mixin _$ArtistDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArtistsTable get artists => db.artists;
}
mixin _$ArtDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArtsTable get arts => db.arts;
}
mixin _$QueueItemDaoMixin on DatabaseAccessor<AppDatabase> {
  $QueueItemsTable get queueItems => db.queueItems;
}
