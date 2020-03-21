import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/main.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

doIsolated(Directory list) async {
  Directory docs = await getApplicationDocumentsDirectory();
  Directory thumbs = Directory(docs.path + "/thumbs");
  await thumbs.create();
  final FlutterFFmpegConfig _flutterFFmpegConfig = new FlutterFFmpegConfig();
  _flutterFFmpegConfig.disableLogs();
 // _flutterFFmpegConfig.disableStatistics();
//  _flutterFFmpegConfig.disableRedirection();
  await MusicFinder().readFolderIntoDatabase([list, docs, thumbs]);
  //compute(main, [list, docs, thumbs]);
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
    List<Insertable<PlaylistItem>> playlistItems = new List();
    Art defaultArt;

    await Future.forEach(files, (f) async {
      if (f is File) {
        String ending = "." + f.uri
            .toString()
            .split(".")
            .last;
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

    insertSong(SongsCompanion song) async {
      var id = await database.songDao.insert(song);
      if(id != null) { //null if already exists
        //insert song into "all songs" playlist
        playlistItems.add(PlaylistItem(playlistId: 1, songId: id));
        //insert song into "album" playlist
        playlistItems
            .add(PlaylistItem(playlistId: currentAlbum.playlistId, songId: id));
        //insert song into "artist" playlist
        playlistItems
            .add(
            PlaylistItem(playlistId: currentArtist.playlistId, songId: id));
        await database.playlistItemDao.insertAll(playlistItems);
        playlistItems.clear();
      }
    }

    await Future.forEach(songFiles, (f) async {
      insertSong(await _readFile(defaultArt, folder, f));
    });

    await Future.forEach(directories, (d) async {
      await _readFolder(d);
    });
  }

  Future<SongsCompanion> _readFile(Art defaultArt, Directory folder,
      File file) async {
    String songTitle;
    String songArtist;
    String songAlbum;
    Art art;
    int songDuration = 0;
    var info = await _flutterFFprobe.getMediaInformation(file.path);
    songDuration = info['duration'] ?? 0;

    //fallback and image
    //TODO too slow always opening new thread work with callbacks
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
      songAlbum = folder.path
          .split("/")
          .last;
    }

    if (songArtist == null || songArtist.isEmpty) {
      songArtist = "Unkown";
    }

    if (art == null) {
      art = defaultArt;
    }

    currentAlbum = await _findAlbum(songAlbum, art);
    currentArtist = await _findArtist(currentArtist, songArtist);

    return SongsCompanion.insert(
        path: file.path,
        title: songTitle,
        artist: songArtist,
        duration: songDuration,
        artCrc: Value(art?.crc ?? null),
        albumName: Value(currentAlbum.name),
        artistName: Value(currentArtist.name));
  }

  Future<Album> _findAlbum(String album, Art art) async {
    //save songs that i have read until now
    if (currentAlbum?.name != album) {
      //search album for song
      currentAlbum = await database.albumDao.findAlbumByName(album);

      if (currentAlbum == null) {
        //create playlist for album
        var playlistId = await database.playlistDao
            .insert(PlaylistsCompanion.insert(name: album, type: 1));
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
            .insert(PlaylistsCompanion.insert(name: artist, type: 2));
        //create new album
        currentArtist = Artist(name: artist, playlistId: playlistId);
        //insert album
        await database.artistDao.insert(currentArtist);
      }
    }
    return currentArtist;
  }

  Future<Art> _findArt(List<int> imageData, Directory thumbs,
      int crcText) async {
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
