import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrackList extends StatefulWidget {
  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  @override
  final numItems = 20;

  Widget _buildRow(int idx) {
    return ListTile(
      leading: CircleAvatar(
        child: Text('$idx'),
      ),
      title: Text('Track $idx'),
      trailing: Icon(Icons.play_arrow),
    );
  }

  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: numItems,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context, int i) {
          if(i.isOdd) return Divider();
          final index = i ~/ 2 +1;
          return _buildRow(index);
        }
    );
  }
}
