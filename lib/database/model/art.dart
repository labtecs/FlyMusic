import 'package:floor/floor.dart';

@Entity(tableName: 'Art')
class Art {
  @PrimaryKey(autoGenerate: true)
  int id;
  String path;
  String crc;

  Art(this.id, this.path, this.crc);
}
