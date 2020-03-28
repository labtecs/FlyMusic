import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/screens/main_screen.dart';
import 'package:flymusic/screens/tabScreens/other/song_item.dart';
import 'package:provider/provider.dart';

//TODO pagination https://pub.dev/packages/pagination_view#-readme-tab-

class TrackList extends StatefulWidget {
  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList>
    with AutomaticKeepAliveClientMixin<TrackList> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: StreamBuilder<List<SongWithArt>>(
        stream: Provider.of<SongDao>(context).findAllSongsWithArt(),
        builder:
            (BuildContext context, AsyncSnapshot<List<SongWithArt>> snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return buildSongItem(snapshot.data[index], 1, context);
              },
            );
          } else {
            return emptyScreen(context, tr("empty_page", context: context));
          }
        },
      ),
    );
  }
}
