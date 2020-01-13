import 'package:floor/floor.dart';

@entity
class Song {
  @primaryKey
  int id;
  String artist;
  String title;
  String album;
  int albumId;
  int duration;
  String uri;
  String albumArtUri;

  Song(this.id, this.artist, this.title, this.album, this.albumId,
      this.duration, this.uri);
}
