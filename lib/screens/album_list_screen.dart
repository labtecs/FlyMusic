import 'package:flutter/material.dart';
import 'package:flymusic/database/model/album.dart';
import 'package:flymusic/main.dart';

class AlbumList extends StatefulWidget {
  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {

  List<Album> albems = List();


  Widget _buildRow(Album album) {
    return ListTile(
      leading: CircleAvatar(
        child: Image.asset("asset/images/placeholder.jpg"),
        backgroundColor: Colors.transparent,
      ),
      title: Text(album.name),
      onTap: () {
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Album>>(
        future: database.albumDao.findAllAlbums(),
        builder: (BuildContext context, AsyncSnapshot<List<Album>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return _buildRow(snapshot.data[index]);
              },
            );
          } else {
            return Text("no data");
          }
        },
      ),
    );


  }
}

