import 'package:flutter/material.dart';

class ArtistTrackListScreen extends StatefulWidget {

  String artistName;
  ArtistTrackListScreen({Key key, this.artistName}) : super (key: key);

  @override
  _ArtistTrackListScreenState createState() => _ArtistTrackListScreenState();
}

class _ArtistTrackListScreenState extends State<ArtistTrackListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //ArtistID fehlt noch in der Datenbank
    );
  }
}
