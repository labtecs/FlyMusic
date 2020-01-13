import 'package:floor/floor.dart';

@entity
class Album {
  @primaryKey
  final int id;
  final String name;
  final String albumArt;

  Album(this.id, this.name, this.albumArt);
}