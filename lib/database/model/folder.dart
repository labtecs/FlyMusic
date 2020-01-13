import 'package:floor/floor.dart';

@entity
class Folder {
  @primaryKey
  final int id;
  final String name;
  final String path;

  Folder(this.id, this.name, this.path);
}