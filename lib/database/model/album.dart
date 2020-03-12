import 'package:floor/floor.dart';
import 'package:flymusic/database/model/art.dart';

@Entity(tableName: 'Album')
class Album {
  @PrimaryKey(autoGenerate: true)
  int id;
  final String name;
  int artId;

  @ignore
  Art art;

  Album(this.id, this.name, this.artId);
}