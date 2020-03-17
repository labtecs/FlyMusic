import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

//how this isolate works in detail https://moor.simonbinder.eu/docs/advanced-features/isolates/

// This needs to be a top-level method because it's run on a background isolate
DatabaseConnection _backgroundConnection() {
  // construct the database. You can also wrap the VmDatabase in a "LazyDatabase" if you need to run
  // work before the database opens.
  final database = VmDatabase.memory();
  return DatabaseConnection.fromExecutor(database);
}

doWork(Directory list) async {
  // create a moor executor in a new background isolate. If you want to start the isolate yourself, you
  // can also call MoorIsolate.inCurrent() from the background isolate
  MoorIsolate isolate = await MoorIsolate.spawn(_backgroundConnection);

  // we can now create a database connection that will use the isolate internally. This is NOT what's
  // returned from _backgroundConnection, moor uses an internal proxy class for isolate communication.
  DatabaseConnection connection = await isolate.connect();

  final db = AppDatabase.connect(connection);

  // you can now use your database exactly like you regularly would, it transparently uses a
  // background isolate internally
  await MusicFinder.instance.readFolderIntoDatabase(list, db);
}

class MusicFinder {
  final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();
  static final MusicFinder instance = MusicFinder._internal();

  factory MusicFinder() => instance;

  MusicFinder._internal();

  TagProcessor tp = new TagProcessor();
  List<Song> songs = new List();
  Album currentAlbum;
  Artist currentArtist;
  Directory thumbs;
  Directory docs;
  AppDatabase database;

  initialize() async {
    docs = await getApplicationDocumentsDirectory();
    thumbs = Directory(docs.path + "/thumbs");
    thumbs.createSync();
    final FlutterFFmpegConfig _flutterFFmpegConfig = new FlutterFFmpegConfig();
    await _flutterFFmpegConfig.disableLogs();
  }

  readFolderIntoDatabase(Directory folder, AppDatabase database) async {
    this.database = database;
    await _readFolder(folder);
  }

  Future<void> _readFolder(FileSystemEntity folder) async {
    List<FileSystemEntity> files =
        (folder as Directory).listSync(recursive: false);

    List<Directory> directories = new List();
    List<File> songFiles = new List();
    List<Song> songs = new List();
    Art defaultArt;

    await Future.forEach(files, (f) async {
      if (f is File) {
        String ending = "." + f.uri.toString().split(".").last;
        switch (ending) {
          case ".mp3":
            songFiles.add(f);
            break;
          case ".jpg":
          case ".jpeg":
          case ".png":
            if (defaultArt == null) {
              Uint8List bytes = f.readAsBytesSync();
              int crcText = getCrc32(bytes);
              if (crcText != null) {
                defaultArt = await _findArt(bytes, thumbs, crcText);
              }
              if (defaultArt == null) {
                File file = File('${thumbs.path}/$crcText$ending');
                await file.writeAsBytes(bytes);
                defaultArt = new Art(path: file.path, crc: crcText.toString());
                //TODO test defaultArt.id = await database.artDao.insertArt(defaultArt);
              }
            }
            break;
        }
      } else if (f is Directory) {
        directories.add(f);
      }
    });

    await Future.forEach(songFiles, (f) async {
      songs.add(await _readFile(defaultArt, folder, f));
      if (songs.length >= 100) {
        await database.songDao.insertAll(songs);
        songs.clear();
      }
    });

    await database.songDao.insertAll(songs);
    songs.clear();

    await Future.forEach(directories, (d) async {
      await _readFolder(d);
    });
  }

  Future<Song> _readFile(Art defaultArt, Directory folder, File file) async {
    String songTitle;
    String songArtist;
    String songAlbum;
    Art art;

    int songDuration = 0;
    _flutterFFprobe.getMediaInformation(file.path).then((info) {
      songDuration = info['duration'];
    });

    //fallback and image
    var tags = await tp.getTagsFromByteArray(file.readAsBytes());

    await Future.forEach(tags, (f) async {
      if (f.version == '1.1') {
        if ((songTitle == null || songTitle.isEmpty) &&
            f.tags.containsKey('title')) {
          songTitle = f.tags['title'];
        }
        if ((songArtist == null || songArtist.isEmpty) &&
            f.tags.containsKey('artist')) {
          songArtist = f.tags['artist'];
        }
        if ((songAlbum == null || songAlbum.isEmpty) &&
            f.tags.containsKey('album')) {
          songAlbum = f.tags['album'];
        }
      }
      if (f.tags.containsKey('picture')) {
        AttachedPicture image = (f.tags['picture'] as AttachedPicture);
        // if (isBase64(image.imageData64)) {
        int crcText = getCrc32(image.imageData);
        if (crcText != null) {
          art = await _findArt(image.imageData, thumbs, crcText);
        }
      }
    });

    if (songTitle == null || songTitle.isEmpty) {
      songTitle = basename(file.path);
    }

    if (songAlbum == null || songAlbum.isEmpty) {
      songAlbum = folder.path.split("/").last;
    }

    if (songArtist == null || songArtist.isEmpty) {
      songArtist = "Unkown";
    }

    if (art == null) {
      art = defaultArt;
    }

    Album album = await _findAlbum(songAlbum, art);
    Artist artist = await _findArtist(currentArtist, songArtist);
//TODO empty art in database
    return Song(
        id: null,
        title: songTitle,
        artist: songArtist,
        uri: file.path,
        duration: songDuration,
        artCrc: art.crc,
        albumName: songAlbum,
        artistName: songArtist);
  }

  Future<Album> _findAlbum(String album, Art art) async {
    //save songs that i have read until now
    if (currentAlbum?.name != album) {
      //search album for song
      currentAlbum = await database.albumDao.findAlbumByName(album);

      if (currentAlbum == null) {
        //create new album
        currentAlbum = Album(name: album, artCrc: art.crc);
        //insert album
        await database.albumDao.insert(currentAlbum);
        //TODO test currentAlbum.id = await database.albumDao.insertAlbum(currentAlbum);
      }
      // TODO if (currentAlbum.artId == -1 && art != null && art.id != -1) {
      //   currentAlbum.artId = art.id;
      //   await database.albumDao.updateAlbum(currentAlbum);
      //  }
    }
    return currentAlbum;
  }

  Future<Artist> _findArtist(Artist currentArtist, String artist) async {
    //save songs that i have read until now
    if (currentArtist?.name != artist) {
      //search album for song
      currentArtist = await database.artistDao.findArtistByName(artist);

      if (currentArtist == null) {
        //create new album
        currentArtist = Artist(name: artist);
        //insert album
        await database.artistDao.insert(currentArtist);
        //TODO test currentArtist.id =
      }
    }
    return currentArtist;
  }

  Future<Art> _findArt(
      List<int> imageData, Directory thumbs, int crcText) async {
    Art art = await database.artDao.findArtByCrc(crcText.toString());
    if (art == null) {
      File file = File('${thumbs.path}/$crcText.jpg');
      await file.writeAsBytes(imageData);
      art = new Art(crc: crcText.toString(), path: file.path);
      await database.artDao.insert(art);
      //TODO test art.id
    }
    return art;
  }
}
