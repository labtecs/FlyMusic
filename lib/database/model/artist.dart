import 'package:floor/floor.dart';

@Entity(tableName: 'Artist')
class Artist {
  @PrimaryKey(autoGenerate: true)
  int id;
  String name;

  Artist(this.id, this.name);
}
