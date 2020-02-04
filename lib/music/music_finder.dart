import 'dart:io';
import 'package:flymusic/database/model/album.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/main.dart';
import 'package:path/path.dart';
import 'package:dart_tags/dart_tags.dart';

class MusicFinder {
  static readFolderIntoDatabase(Directory folder) async {
    //list all fields
    List<FileSystemEntity> files = new List();
    List<Song> songs = new List();
    files = folder.listSync(
        recursive: true); //use your folder name instead of resume.

    Album currentAlbum;

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
                art = (f.tags['picture'] as AttachedPicture).imageData64;
              }
            });
          }); //title, artist, album



          if (title == null || title.isEmpty) {
            title = basename(file.path);
          }

          if (album != null) {
            if (currentAlbum == null || currentAlbum.name != album) {
              //save songs that i have read until now
              if (currentAlbum != null && currentAlbum.name != album) {
                List<int> keys = await database.songDao.insertAllSongs(songs);
                songs.clear();
              }
              //search album for song
              currentAlbum = await database.albumDao.findAlbumByName(album);

              if (currentAlbum == null) {
                //create new album
                currentAlbum = Album(null, album, art);
                //insert album
                await database.albumDao.insertAlbum(currentAlbum);
              }
            }
            songs.add(
                Song(null, title, artist, art, currentAlbum.id, 0, file.path));
          }
        }
      }
    }
    await database.songDao.insertAllSongs(songs);
    songs.clear();
  }
}




/*
 for (FileSystemEntity file in files) {
      if (file is File) {
        if (file.uri.toString().endsWith(".mp3")) {
          TagProcessor tp = new TagProcessor();
          List<Tag> tags = await tp.getTagsFromByteData(
              ByteData.view(file.readAsBytesSync().buffer));

          String title = '';
          String artist = '';
          String album = '';
          String art;

          tags.forEach((tag) => {
                if (tag.tags.containsKey('title'))
                  {title = tag.tags['title']}
                else if (tag.tags.containsKey('artist'))
                  {artist = tag.tags['artist']}
                else if (tag.tags.containsKey('album'))
                  {album = tag.tags['album']}
                  else if (tag.tags.containsKey('Picture'))
                      {art = (tag.tags['Picture'] as AttachedPicture).imageData64}
              });

          /*
          if (mp3instance.metaTags['APIC'] is LinkedHashMap<String, dynamic>) {
            if ((mp3instance.metaTags['APIC'] as LinkedHashMap<String, dynamic>).containsKey('base64')) {
              art = (mp3instance.metaTags['APIC'] as LinkedHashMap<String, dynamic>)['base64'];
            }
          }
        */

          if (title == null || title.isEmpty) {
            title = basename(file.path);
          }

          if (album != null) {
            if (currentAlbum == null || currentAlbum.name != album) {
              //save songs that i have read until now
              if (currentAlbum != null && currentAlbum.name != album) {
                List<int> keys = await database.songDao.insertAllSongs(songs);
                songs.clear();
                print(keys);
              }
              //search album for song
              currentAlbum = await database.albumDao.findAlbumByName(album);

              if (currentAlbum == null) {
                //create new album
                currentAlbum = Album(null, album, art);
                //insert album
                await database.albumDao.insertAlbum(currentAlbum);
              }
            }
            songs.add(
                Song(null, title, artist, art, currentAlbum.id, 0, file.path));
          }
        }
      }
    }
    await database.songDao.insertAllSongs(songs);
    songs.clear();
  }
}
 */