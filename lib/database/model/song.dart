import 'package:floor/floor.dart';

@entity
class Song {
  @primaryKey
  final int id;
  final String title;
  final String artist;
  final int time;
  final int folderId;

  Song({this.id, this.title, this.artist, this.time, this.folderId});
}
