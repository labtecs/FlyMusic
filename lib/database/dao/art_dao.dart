import 'package:floor/floor.dart';
import 'package:flymusic/database/model/art.dart';

@dao
abstract class ArtDao {

  @insert
  Future<int> insertArt(Art art);

  @Query('SELECT * FROM Art WHERE id = :id LIMIT 1')
  Future<Art> findArtById(int id);

  @Query('SELECT * FROM Art WHERE crc = :crc LIMIT 1')
  Future<Art> findArtByCrc(int crc);

}