import 'package:floor/floor.dart';

@Entity(tableName: 'Art')
class Art {
  @PrimaryKey(autoGenerate: true)
  int id;
  String path;
  int crc;

  Art(this.id, this.path, int crc);
}
