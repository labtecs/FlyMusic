import 'package:floor/floor.dart';

@Entity(tableName: 'Song')
class Song {
  @PrimaryKey(autoGenerate: true)
  int id;
  String title;
  String artist;
  int artId;
  int albumId;
  int duration;
  String uri;
  int artistId;

  Song(this.id, this.title, this.artist, this.artId, this.albumId,
      this.duration, this.uri, this.artistId);
}
