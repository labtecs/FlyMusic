import 'package:floor/floor.dart';

@Entity(tableName: 'Art')
class Art {
  @PrimaryKey(autoGenerate: true)
  int id;
  String base64;

  Art(this.id, this.base64);
}
