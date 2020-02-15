import 'dart:io';

import 'package:crclib/crclib.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:flymusic/database/model/album.dart';
import 'package:flymusic/database/model/art.dart';
import 'package:flymusic/database/model/artist.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/main.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

//TODO song no image -> album image
class MusicFinder {
  static readFolderIntoDatabase(Directory folder) async {
    Directory docs = await getApplicationDocumentsDirectory();
    Directory thumbs = Directory(docs.path + "/thumbs");
    thumbs.createSync();

    //list all fields
    List<FileSystemEntity> files = new List();
    List<Song> songs = new List();
    files = folder.listSync(
        recursive: true); //use your folder name instead of resume.

    Album currentAlbum;
    Artist currentArtist;

    TagProcessor tp = new TagProcessor();

    for (FileSystemEntity file in files) {
      if (file is File) {
        if (file.uri.toString().endsWith(".mp3")) {
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
              int crcText = new Crc32Zlib().convert(image.imageData);
              if (crcText != null) {
                art = await findArt(image, thumbs, crcText);
              }
            }
          });

          if (title == null || title.isEmpty) {
            title = basename(file.path);
          }

          if (album == null || album.isEmpty) {
            album = "Unkown";
          }

          if (artist == null || artist.isEmpty) {
            artist = "Unkown";
          }

          Album newAlbum = await findAlbum(currentAlbum, album, art);
          if (newAlbum != currentAlbum) {
            await database.songDao.insertAllSongs(songs);
            songs.clear();
            currentAlbum = newAlbum;
          }

          currentArtist = await findArtist(currentArtist, artist);

          songs.add(Song(null, title, artist, art?.id ?? -1, currentAlbum.id, 0,
              file.path, currentArtist.id));
        }
      }
    }
    await database.songDao.insertAllSongs(songs);
    songs.clear();
  }

  static Future<Album> findAlbum(
      Album currentAlbum, String album, Art art) async {
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
    }
    return currentAlbum;
  }

  static Future<Artist> findArtist(Artist currentArtist, String artist) async {
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

  static Future<Art> findArt(
      AttachedPicture image, Directory thumbs, int crcText) async {
    Art art = await database.artDao.findArtByCrc(crcText.toString());
    if (art == null) {
      File file = File('${thumbs.path}/$crcText.jpg');
     // var jpg = decodeJpg(image.imageData);
   //   if (jpg != null) {
        await file.writeAsBytes(image.imageData);
        art = new Art(null, file.path, crcText.toString());
        art.id = await database.artDao.insertArt(art);
    //  }
    }
    return art;
  }
}
