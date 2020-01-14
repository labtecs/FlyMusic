import 'dart:io';

import 'package:dart_tags/dart_tags.dart';
import 'package:media_metadata_plugin/media_media_data.dart';
import 'package:media_metadata_plugin/media_metadata_plugin.dart';

import '../database/app_database.dart';
import '../database/model/album.dart';
import '../database/model/song.dart';
import '../main.dart';

class MusicFinder {
  static readFolderIntoDatabase(Directory folder) async {
    //list all fields
    List<FileSystemEntity> files = new List();
    List<Song> songs = new List();
    files = folder.listSync(); //use your folder name instead of resume.

    TagProcessor tp = new TagProcessor();

    Album currentAlbum = null;

    for (File file in files) {
      String title;
      String artist;
      String album;
      int duration;

      tp.getTagsFromByteArray(file.readAsBytes()).then((l) {
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
        });
      }); //title, artist, album

      //doesn't always find title
      AudioMetaData metaData =
          await MediaMetadataPlugin.getMediaMetaData(file.path);
      duration = metaData.trackDuration;
      if (title.isEmpty) {
        title = metaData.trackName;
      }
      if (artist.isEmpty) {
        artist = metaData.artistName;
      }
      if (album.isEmpty) {
        album = metaData.album;
      }
      print(metaData);

      //TODO album bild auslesen (wie?)

      if(currentAlbum == null || currentAlbum.name != album){
        //save songs that i have read until now
        if(currentAlbum.name != album){
          await database.songDao.insertAllSongs(songs);
        }

        //search album for song
        currentAlbum = await database.albumDao.findAlbumByName(album);

        if(currentAlbum == null){
          //create new album
          currentAlbum = Album(0, album, "");
          //insert album
          await database.albumDao.insertAlbum(currentAlbum);
        }
      }

      songs.add(Song(0, title, artist, currentAlbum.id, duration, file.path));
    }
  }
//title, artist, album,
}
