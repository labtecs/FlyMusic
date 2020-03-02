import 'package:flutter/material.dart';
import 'package:flymusic/database/model/queue_item.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/main.dart';
import 'package:flymusic/screens/drawerScreens/player_screen.dart';

import '../main_screen.dart';

class QueueScreen extends StatefulWidget {
  @override
  _QueueScreenState createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  List<Song> songs = List();

  Widget _buildRow(QueueItem queueItem) {
    return FutureBuilder<Song>(
        future: database.songDao.findSongById(queueItem.songId),
        // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Song> snapshot) {
          if (snapshot.hasData) {
            return ListTile(
              leading: CircleAvatar(
                child: StartScreen.getArt(snapshot.data.artId),
                backgroundColor: Colors.transparent,
              ),
              title: Text(snapshot.data.title),
              trailing: Icon(Icons.delete),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PlayerScreen()));
              },
            );
          } else {
            return Text("loading");
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<QueueItem>>(
      stream: database.queueDao.findAllItems(),
      builder: (BuildContext context, AsyncSnapshot<List<QueueItem>> snapshot) {
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
    ));
  }
}
