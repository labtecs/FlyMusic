import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flymusic/database/model/album.dart';
import 'package:flymusic/database/model/art.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/main.dart';

class ArtUtil {
  static Widget getArtFromSong(Song song) {
    if (song.art != null && song.artId == song.art.id) {
      return Image.file(File(song.art.path), fit: BoxFit.cover);
    }
    return FutureBuilder<Art>(
        future: database.artDao.findArtById(song?.artId ?? -1),
        builder: (BuildContext context, AsyncSnapshot<Art> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            song.art = snapshot.data;
            return Image.file(File(snapshot.data.path), fit: BoxFit.cover);
          } else {
            return Image(image: AssetImage("asset/images/placeholder.jpg"));
          }
        });
  }

  static Widget getArtFromAlbum(Album album) {
    if (album.art != null && album.artId == album.art.id) {
      return Image.file(File(album.art.path), fit: BoxFit.cover);
    }
    return FutureBuilder<Art>(
        future: database.artDao.findArtById(album?.artId ?? -1),
        builder: (BuildContext context, AsyncSnapshot<Art> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.file(File(snapshot.data.path), fit: BoxFit.cover);
          } else {
            return Image(image: AssetImage("asset/images/placeholder.jpg"));
          }
        });
  }
}
