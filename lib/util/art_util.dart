import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:provider/provider.dart';

//TODO Exception: Could not instantiate image codec. -> placeholder (auch in datenbank)
class ArtUtil {
  static Widget getArtFromSong(Song song, BuildContext context) {
    if (song == null || song.artCrc == null) {
      return Image(image: AssetImage("asset/images/placeholder.jpg"));
    }
    return FutureBuilder<Art>(
        future: Provider.of<ArtDao>(context).findArtByCrc(song.artCrc),
        builder: (BuildContext context, AsyncSnapshot<Art> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.file(File(snapshot.data.path), fit: BoxFit.cover);
          } else {
            return Image(image: AssetImage("asset/images/placeholder.jpg"));
          }
        });
  }

  static Widget getArtFromAlbum(Album album, BuildContext context) {
    if (album == null || album.artCrc == null) {
      return Image(image: AssetImage("asset/images/placeholder.jpg"));
    }
    return FutureBuilder<Art>(
        future: Provider.of<ArtDao>(context).findArtByCrc(album.artCrc),
        builder: (BuildContext context, AsyncSnapshot<Art> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.file(File(snapshot.data.path), fit: BoxFit.cover);
          } else {
            return Image(image: AssetImage("asset/images/placeholder.jpg"));
          }
        });
  }
}
