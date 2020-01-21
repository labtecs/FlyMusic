import 'package:flutter/material.dart';

class AlbumList extends StatefulWidget {
  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.vertical,
        children: List.generate(100, (index) {
      return Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 4.0),
            ),
            child: Image.asset('asset/images/Cover1.jpg'),
          ),
      );
    }),
    );
  }
}
