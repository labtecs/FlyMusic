import 'package:floor/floor.dart';

@Entity(tableName: 'Album')
class Album {
  @PrimaryKey(autoGenerate: true)
  int id;
  final String name;
  final int artId;

  Album(this.id, this.name, this.artId);
}