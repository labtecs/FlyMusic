import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:flymusic/database/model/album.dart';
import 'package:flymusic/database/model/art.dart';
import 'package:flymusic/database/model/artist.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/main.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class MusicFinder {
  static final MusicFinder instance = MusicFinder._internal();

  factory MusicFinder() => instance;

  MusicFinder._internal();

  TagProcessor tp = new TagProcessor();
  List<Song> songs = new List();
  Album currentAlbum;
  Artist currentArtist;
  Directory thumbs;

  readFolderIntoDatabase(Directory folder) async {
    Directory docs = await getApplicationDocumentsDirectory();
    thumbs = Directory(docs.path + "/thumbs");
    thumbs.createSync();
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
                defaultArt = new Art(null, file.path, crcText.toString());
                defaultArt.id = await database.artDao.insertArt(defaultArt);
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
        await database.songDao.insertAllSongs(songs);
        songs.clear();
      }
    });

    await database.songDao.insertAllSongs(songs);
    songs.clear();

    await Future.forEach(directories, (d) async {
      await _readFolder(d);
    });
  }

  Future<Song> _readFile(Art defaultArt, Directory folder, File file) async {
    String title;
    String artist;
    Art art;
    String album;

    var tags = await tp.getTagsFromByteArray(file.readAsBytes());

    await Future.forEach(tags, (f) async {
      if (f.version == '1.1') {
        if (f.tags.containsKey('title')) {
          title = f.tags['title'];
        }
        if (f.tags.containsKey('artist')) {
          artist = f.tags['artist'];
        }
        if (f.tags.containsKey('album')) {
          album = f.tags['album'];
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

    if (title == null || title.isEmpty) {
      title = basename(file.path);
    }

    if (album == null || album.isEmpty) {
      album = folder.path.split("/").last;
    }

    if (artist == null || artist.isEmpty) {
      artist = "Unkown";
    }

    if (art == null) {
      art = defaultArt;
    }

    Album songAlbum = await _findAlbum(album, art);
    Artist songArtist = await _findArtist(currentArtist, artist);

    return Song(null, title, artist, art?.id ?? -1, songAlbum.id, 0, file.path,
        songArtist.id);
  }

  Future<Album> _findAlbum(String album, Art art) async {
    //save songs that i have read until now
    if (currentAlbum?.name != album) {
      //search album for song
      currentAlbum = await database.albumDao.findAlbumByName(album);

      if (currentAlbum == null) {
        //create new album
        currentAlbum = Album(null, album, art?.id ?? -1);
        //insert album
        currentAlbum.id = await database.albumDao.insertAlbum(currentAlbum);
      }
      if (currentAlbum.artId == -1 && art.id != -1) {
        currentAlbum.artId = art.id;
        await database.albumDao.updateAlbum(currentAlbum);
      }
    }
    return currentAlbum;
  }

  static Future<Artist> _findArtist(Artist currentArtist, String artist) async {
    //save songs that i have read until now
    if (currentArtist?.name != artist) {
      //search album for song
      currentArtist = await database.artistDao.findArtistByName(artist);

      if (currentArtist == null) {
        //create new album
        currentArtist = Artist(null, artist);
        //insert album
        currentArtist.id = await database.artistDao.insertArtist(currentArtist);
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
      art = new Art(null, file.path, crcText.toString());
      art.id = await database.artDao.insertArt(art);
    }
    return art;
  }
}
