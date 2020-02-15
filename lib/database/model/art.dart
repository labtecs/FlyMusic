import 'dart:wasm';

import 'package:floor/floor.dart';

@Entity(tableName: 'Art')
class Art {
  @PrimaryKey(autoGenerate: true)
  int id;
  String path;
  String check;

  Art(this.id, this.path, String check);
}
