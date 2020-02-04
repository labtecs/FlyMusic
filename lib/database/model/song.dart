import 'package:floor/floor.dart';

@Entity(tableName: 'Song')
class Song {
  @PrimaryKey(autoGenerate: true)
  int id;
  String title;
  String artist;
  String songArt;
  int albumId;
  int duration;
  String uri;

  Song(this.id, this.title, this.artist, this.songArt, this.albumId,
      this.duration, this.uri);
}


