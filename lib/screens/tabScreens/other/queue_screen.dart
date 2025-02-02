import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/screens/main_screen.dart';
import 'package:flymusic/screens/tabScreens/other/song_item.dart';
import 'package:flymusic/util/art_util.dart';
import 'package:provider/provider.dart';

class QueueScreen extends StatefulWidget {
  @override
  _QueueScreenState createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen>
    with AutomaticKeepAliveClientMixin<QueueScreen> {
  @override
  bool get wantKeepAlive => true;

  List<Song> songs = List();

  Widget _buildRow(QueueItemWithPlaylistAndSongAndArt queueItem) {
    if (queueItem.header) {
      if (queueItem.queueItem.isManuallyAdded) {
        return ListTile(
            title: Text(tr('next_in_queue', context: context),
                style: Theme.of(context).textTheme.subtitle1));
      }
      return ListTile(
        title: Text(
            tr('from_playlist', context: context) + queueItem.playlist.name,
            style: Theme.of(context).textTheme.subtitle1),
      );
    } else {
      return ListTile(
        leading: CircleAvatar(
          child: ArtUtil.getArtFromSongWithArt(
              SongWithArt(song: queueItem.song, art: queueItem.art), context),
          backgroundColor: Colors.transparent,
        ),
        title: Text(queueItem.song.title),
        subtitle:
            Text(timestamp(Duration(milliseconds: queueItem.song.duration))),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            MusicQueue.instance.remove(queueItem.queueItem);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: StreamBuilder<List<QueueItemWithPlaylistAndSongAndArt>>(
      stream: Provider.of<QueueItemDao>(context)
          .getGroupedItemsAfterCurrentWithSongAndArt(
              MusicQueue.instance.currentItem?.position ?? 0),
      builder: (BuildContext context,
          AsyncSnapshot<List<QueueItemWithPlaylistAndSongAndArt>> snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return _buildRow(snapshot.data[index]);
            },
          );
        } else {
          return emptyScreen(
              context, tr('no_songs_in_queue', context: context));
        }
      },
    ));
  }
}
