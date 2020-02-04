import 'package:floor/floor.dart';

@Entity(tableName: 'Queue')
class QueueItem {
  @PrimaryKey(autoGenerate: true)
  int id;
  int songId;
  int position;

  QueueItem(this.id, this.songId, this.position);
}
