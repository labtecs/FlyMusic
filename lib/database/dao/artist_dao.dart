import 'package:floor/floor.dart';
import 'package:flymusic/database/model/artist.dart';

@dao
abstract class ArtistDao {
  @Query('SELECT * FROM Artist')
  Stream<List<Artist>> findAllArtists();

  @Query('SELECT * FROM Artist WHERE name = :name')
  Future<Artist> findArtistByName(String name);

  @insert
  Future<int> insertArtist(Artist artist);
}