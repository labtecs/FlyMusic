import 'package:floor/floor.dart';

import 'package:flymusic/database/model/queue_item.dart';

@dao
abstract class QueueDao {
  @Query('SELECT * FROM Queue ORDER BY position DESC')
  Stream<List<QueueItem>> findAllItems();

  @Query('SELECT * FROM Queue WHERE position > :currentPosition ORDER BY position DESC LIMIT 1')
  Future<QueueItem> getNextItem(int currentPosition);

  @Query('SELECT * FROM Queue WHERE position < :currentPosition ORDER BY position ASC LIMIT 1')
  Future<QueueItem> getPreviousItem(int currentPosition);

  @Query('SELECT * FROM Queue ORDER BY position ASC LIMIT 1')
  Future<QueueItem> getLastItem();

  @insert
  Future<void> addItem(QueueItem item);

  @insert
  Future<void> addItems(List<QueueItem> items);

  @Query('UPDATE Queue SET position = position+ :i')
  void moveItemsDownBy(int i);
}