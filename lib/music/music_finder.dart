import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/main.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

doIsolated(Directory list) async {
  Directory docs = await getApplicationDocumentsDirectory();
  Directory thumbs = Directory(docs.path + "/thumbs");
  await thumbs.create();
  final FlutterFFmpegConfig _flutterFFmpegConfig = new FlutterFFmpegConfig();
  _flutterFFmpegConfig.disableLogs();
  await MusicFinder().readFolderIntoDatabase([list, docs, thumbs]);
  //compute(main, [list, docs, thumbs]);
}

main(List<Directory> list) async {
  await MusicFinder().readFolderIntoDatabase(list);
}

readTags(File file) async {
  var tags = await TagProcessor().getTagsFromByteArray(file.readAsBytes());
  return tags;
}

class MusicFinder {
  final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();
  TagProcessor tp = new TagProcessor();
  List<Song> songs = new List();
  Album currentAlbum;
  Artist currentArtist;
  Directory thumbs;
  Directory docs;
  AppDatabase database;

  readFolderIntoDatabase(List<Directory> folder) async {
    //  MoorIsolate isolate = await MoorIsolate.spawn(backgroundConnection);
    //  we can now create a database connection that will use the isolate internally. This is NOT what's
    //    returned from _backgroundConnection, moor uses an internal proxy class for isolate communication.
//    DatabaseConnection connection = await isolate.connect();
    // database = AppDatabase.connect(connection);
    database = MyApp.db;
    docs = folder[1];
    thumbs = folder[2];
    await _readFolder(folder[0]);
  }

  Future<void> _readFolder(FileSystemEntity folder) async {
    List<FileSystemEntity> files =
        (folder as Directory).listSync(recursive: false);

    List<Directory> directories = new List();
    List<File> songFiles = new List();
    List<Song> songs = new List();
    List<Insertable<PlaylistItem>> playlistItems = new List();
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
                await database.artDao.insert(defaultArt);
              }
            }
            break;
        }
      } else if (f is Directory) {
        directories.add(f);
      }
    });

    await Future.forEach(songFiles, (f) async {
      var song = await _readFile(defaultArt, folder, f);
      //insert song into "all songs" playlist
      playlistItems.add(PlaylistItem(playlistId: 0, songPath: song.path));
      //insert song into "album" playlist
      playlistItems.add(PlaylistItem(
          playlistId: currentAlbum.playlistId, songPath: song.path));
      //insert song into "artist" playlist
      playlistItems.add(PlaylistItem(
          playlistId: currentArtist.playlistId, songPath: song.path));

      songs.add(song);
      if (songs.length >= 100) {
        await database.songDao.insertAll(songs);
        await database.playlistItemDao.insertAll(playlistItems);
        playlistItems.clear();
        songs.clear();
      }
    });

    await database.songDao.insertAll(songs);
    await database.playlistItemDao.insertAll(playlistItems);
    playlistItems.clear();
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
    var tags = await compute(readTags, file);

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

    return Song(
        path: file.path,
        title: songTitle,
        artist: songArtist,
        duration: songDuration,
        artCrc: art?.crc ?? "0",
        albumName: album.name,
        artistName: artist.name);
  }

  Future<Album> _findAlbum(String album, Art art) async {
    //save songs that i have read until now
    if (currentAlbum?.name != album) {
      //search album for song
      currentAlbum = await database.albumDao.findAlbumByName(album);

      if (currentAlbum == null) {
        //create playlist for album
        var playlistId = await database.playlistDao
            .insert(PlaylistsCompanion.insert(name: album));
        //create new album
        currentAlbum = Album(
            name: album, artCrc: art?.crc ?? null, playlistId: playlistId);
        //insert album
        await database.albumDao.insert(currentAlbum);
      }
      if (currentAlbum.artCrc == null && art != null && art.crc != null) {
        await database.albumDao
            .updateAlbum(currentAlbum.copyWith(artCrc: art.crc));
      }
    }
    return currentAlbum;
  }

  Future<Artist> _findArtist(Artist currentArtist, String artist) async {
    //save songs that i have read until now
    if (currentArtist?.name != artist) {
      //search album for song
      currentArtist = await database.artistDao.findArtistByName(artist);

      if (currentArtist == null) {
        //create playlist for artist
        var playlistId = await database.playlistDao
            .insert(PlaylistsCompanion.insert(name: artist));
        //create new album
        currentArtist = Artist(name: artist, playlistId: playlistId);
        //insert album
        await database.artistDao.insert(currentArtist);
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
    }
    return art;
  }
}
