import 'package:flymusic/database/moor_database.dart';
import 'package:moor/moor_web.dart';

AppDatabase constructDb({bool logStatements = false}) {
  return AppDatabase(WebDatabase('db', logStatements: logStatements));
}
