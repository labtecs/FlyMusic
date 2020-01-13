import 'dart:io';

import 'package:dart_tags/dart_tags.dart';
import 'package:media_metadata_plugin/media_media_data.dart';
import 'package:media_metadata_plugin/media_metadata_plugin.dart';

import '../database/model/song.dart';

class MusicFinder {
  static readFolderIntoDatabase(Directory folder) async {
    //list all fields
    List<FileSystemEntity> files = new List();
    files = folder.listSync(); //use your folder name instead of resume.

    TagProcessor tp = new TagProcessor();
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

      //TODO read album art
      //TODO create album album if it doesn't exist
      Song song = Song(0, title, artist, album, 0, duration, file.path);
    }
  }
//title, artist, album,
}
