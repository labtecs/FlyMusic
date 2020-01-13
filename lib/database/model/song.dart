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
  String albumArt;

  Song(this.id, this.artist, this.title, this.album, this.albumId,
      this.duration, this.uri, this.albumArt);

  Song.fromMap(Map m) {
    id = m["id"];
    artist = m["artist"];
    title = m["title"];
    album = m["album"];
    albumId = m["albumId"];
    duration = m["duration"];
    uri = m["uri"];
    albumArt = m["albumArt"];
  }
}
