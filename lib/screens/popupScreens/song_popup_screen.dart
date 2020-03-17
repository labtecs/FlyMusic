import 'package:flutter/material.dart';
import 'package:flymusic/music/music_queue.dart';

class SongPopup extends StatefulWidget {
  final Object item;

  SongPopup(this.item);

  @override
  _SongPopupState createState() => _SongPopupState();
}

class _SongPopupState extends State<SongPopup> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Text("Abspielen"),
        ),
        PopupMenuItem(
          value: 1,
          child: Text("Als nächstes Spielen"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Zur Warteschlange hinzufügen"),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 0:
            MusicQueue.instance.playItem(widget.item);
            break;
          case 1:
            MusicQueue.instance.playItemNext(widget.item);
            break;
          case 2:
            MusicQueue.instance.addItem(widget.item);
            break;
        }
      },
    );
  }
}
