import 'package:flutter/material.dart';

class SongPopup extends StatefulWidget {
  @override
  _SongPopupState createState() => _SongPopupState();
}

class _SongPopupState extends State<SongPopup> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Abspielen"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Als nächstes Speilen"),
        ),
        PopupMenuItem(
          value: 3,
          child: Text("Zur Wiedergabeliste hinzufügen"),
        ),
        PopupMenuItem(
          value: 4,
          child: Text("Zur Warteschlange hinzufügen"),
        ),
      ],
    );
  }
}
