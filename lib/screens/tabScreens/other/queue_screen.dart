import 'package:flutter/material.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/screens/tabScreens/other/song_item.dart';
import 'package:flymusic/util/art_util.dart';
import 'package:moor/moor.dart';
import 'package:provider/provider.dart';

class QueueScreen extends StatefulWidget {
  @override
  _QueueScreenState createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  List<Song> songs = List();

  Widget _buildRow(QueueItem queueItem, bool isHeader) {
    if (isHeader) {
      if (queueItem.isManuallyAdded) {
        return ListTile(
            title: Text('Als nächstes in der Warteschlange',
                style: Theme.of(context).textTheme.subhead));
      }
      return FutureBuilder<Playlist>(
          //song id -> playlist id -> name
          future: Provider.of<PlaylistDao>(context)
              .findPlaylistById(queueItem.playlistId),
          // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<Playlist> snapshot) {
            if (snapshot.hasData) {
              return ListTile(
                title: Text('Aus ${snapshot.data.name}',
                    style: Theme.of(context).textTheme.subhead),
              );
            } else {
              return Text("loading");
            }
          });

      return ListTile(
        title: Text('Aus', style: Theme.of(context).textTheme.headline),
        subtitle: Text(
            'manually: ${queueItem.isManuallyAdded} position: ${queueItem.position}'),
      );
    } else {
      return FutureBuilder<Song>(
          future: Provider.of<SongDao>(context).findSongById(queueItem.songId),
          // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<Song> snapshot) {
            if (snapshot.hasData) {
              return ListTile(
                leading: CircleAvatar(
                  child: ArtUtil.getArtFromSong(snapshot.data, context),
                  backgroundColor: Colors.transparent,
                ),
                title: Text(snapshot.data.title),
                subtitle: Text(
                    timestamp(Duration(milliseconds: snapshot.data.duration))),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    MusicQueue.instance.remove(queueItem);
                  },
                ),
              );
            } else {
              return Text("loading");
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<QueryRow>>(
      stream: Provider.of<QueueItemDao>(context).getGroupedItemsAfterCurrent(MusicQueue.instance.currentItem?.position ?? 0),
      builder: (BuildContext context, AsyncSnapshot<List<QueryRow>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              var item = snapshot.data[index];
              return _buildRow(
                  QueueItem(
                      id: item.readInt('id'),
                      position: item.readInt('position'),
                      isManuallyAdded: item.readBool('is_manually_added'),
                      songId: item.readInt('song_id'),
                      playlistId: item.readInt('playlist_id')),
                  item.readBool('header'));
            },
          );
        } else {
          return Text("no data");
        }
      },
    ));
  }
}
