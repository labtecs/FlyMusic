import 'package:flutter/material.dart';

class AlbumTrackListScreen extends StatefulWidget {

  String albumTitle;
  AlbumTrackListScreen({Key key, this.albumTitle}) : super (key: key);
  @override
  _AlbumTrackListScreenState createState() => _AlbumTrackListScreenState();
}

class _AlbumTrackListScreenState extends State<AlbumTrackListScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.albumTitle}"),
      ),
      body: ListTile(

      ),
    );
  }
}
