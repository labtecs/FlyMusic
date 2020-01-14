import 'package:floor/floor.dart';

@Entity(tableName: 'Song')
class Song {
  @PrimaryKey(autoGenerate: true)
  int id;
  String artist;
  String title;
  String songArt;
  int albumId;
  int duration;
  String uri;

  Song(this.id, this.artist, this.title, this.songArt, this.albumId,
      this.duration, this.uri);
}


