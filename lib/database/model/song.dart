import 'package:floor/floor.dart';
import 'package:flymusic/database/model/art.dart';

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

  @ignore
  Art art;

  Song(this.id, this.title, this.artist, this.artId, this.albumId,
      this.duration, this.uri, this.artistId);
}