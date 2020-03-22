import 'package:flutter/material.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/screens/tabScreens/artist/artist_track_list_screen.dart';
import 'package:provider/provider.dart';

class ArtistScreen extends StatefulWidget {
  @override
  _ArtistScreenState createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen>
    with AutomaticKeepAliveClientMixin<ArtistScreen> {
  @override
  bool get wantKeepAlive => true;

  Widget _buildArtistRow(Artist artist) {
    return ListTile(
      leading: CircleAvatar(
        child: Image.asset("asset/images/artist_placeholder.jpg"),
        backgroundColor: Colors.transparent,
      ),
      title: Text(artist.name),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistTrackListScreen(
              key: null,
              artist: artist,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: StreamBuilder<List<Artist>>(
        stream: Provider.of<ArtistDao>(context).findAllArtists(),
        builder: (BuildContext context, AsyncSnapshot<List<Artist>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return _buildArtistRow(snapshot.data[index]);
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
