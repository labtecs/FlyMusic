import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flymusic/database/model/art.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/main.dart';

class ArtUtil {
  static FutureBuilder getArt(int artId) {
    return FutureBuilder<Art>(
        future: database.artDao.findArtById(artId),
        builder: (BuildContext context, AsyncSnapshot<Art> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.file(File(snapshot.data.path), fit: BoxFit.cover);
          } else {
            return Image(image: AssetImage("asset/images/placeholder.jpg"));
          }
        });
  }

  static FutureBuilder getArt2(Song song) {
    return FutureBuilder<Art>(
        future: database.artDao.findArtById(song?.artId ?? -1),
        builder: (BuildContext context, AsyncSnapshot<Art> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return DrawerHeader(
              child: Text(
                song?.title ?? "",
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: Image.file(File(snapshot.data.path)).image)),
            );
            //  return MemoryImage(File(snapshot.data.path));
          } else {
            return DrawerHeader(
              child: Text(
                song?.title ?? "",
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: ExactAssetImage("asset/images/placeholder.jpg"))),
            );
          }
        });
  }

  static FutureBuilder getArt3(int artId) {
    return FutureBuilder<Art>(
        future: database.artDao.findArtById(artId),
        builder: (BuildContext context, AsyncSnapshot<Art> snapshot) {
          try {
            if (snapshot.hasData && snapshot.data != null) {
              return Image.asset(snapshot.data.path);
            } else {
              return Image.asset(
                "asset/images/placeholder.jpg",
              );
            }
          } catch (q) {
            //should never be used
            print("Bild konnte nicht geladen werden: " + snapshot.data.path);
            return Image.asset(
              "asset/images/placeholder.jpg",
            );
          }
        });
  }
}
