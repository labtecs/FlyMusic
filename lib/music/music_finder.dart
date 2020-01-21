import 'dart:collection';
import 'dart:io';

import 'package:id3/id3.dart';
import 'package:path/path.dart';

import '../database/model/album.dart';
import '../database/model/song.dart';
import '../main.dart';

class MusicFinder {
  static readFolderIntoDatabase(Directory folder) async {
    //list all fields
    List<FileSystemEntity> files = new List();
    List<Song> songs = new List();
    files = folder.listSync(
        recursive: true); //use your folder name instead of resume.

    Album currentAlbum;

    for (FileSystemEntity file in files) {

      if (file is File) {
        if (file.uri.toString().endsWith(".mp3")) {
          MP3Instance mp3instance = new MP3Instance(file.path);
          mp3instance.parseTagsSync();
          String title = mp3instance.metaTags['Title'];
          String artist = mp3instance.metaTags['Artist'];
          String art;

          if (mp3instance.metaTags['APIC'] is HashMap<String, dynamic>) {
            if ((mp3instance.metaTags['APIC'] as HashMap<String, dynamic>)
                .containsKey('base64')) {
              art = (mp3instance.metaTags['APIC']
                  as HashMap<String, dynamic>)['base64'];
            }
          }

          String album = mp3instance.metaTags['Album'];

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
            songs.add(Song(null, title, artist, art, currentAlbum.id, 0,
                file.path));
          }
        }
      }
    }
    await database.songDao.insertAllSongs(songs);
    songs.clear();
  }
}
