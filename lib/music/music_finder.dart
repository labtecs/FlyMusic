import 'dart:io';
import 'package:dart_tags/dart_tags.dart';
import 'package:flymusic/database/model/album.dart';
import 'package:flymusic/database/model/artist.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/main.dart';
import 'package:path/path.dart';
import 'package:string_validator/string_validator.dart';

class MusicFinder {
  static readFolderIntoDatabase(Directory folder) async {
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
          String art;
          String album;

          await tp.getTagsFromByteArray(file.readAsBytes()).then((l) {
            l.forEach((f) {
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
                String image =
                    (f.tags['picture'] as AttachedPicture).imageData64;
                if (isBase64(image)) {
                  art = image;
                }
              }
            });
          }); //title, artist, album

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

          songs.add(Song(null, title, artist, art, currentAlbum.id, 0,
              file.path, currentArtist.id));
        }
      }
    }
    await database.songDao.insertAllSongs(songs);
    songs.clear();
  }

  static Future<Album> findAlbum(
      Album currentAlbum, String album, String art) async {
    //save songs that i have read until now
    if (currentAlbum?.name != album) {
      //search album for song
      currentAlbum = await database.albumDao.findAlbumByName(album);

      if (currentAlbum == null) {
        //create new album
        currentAlbum = Album(null, album, art);
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
}
