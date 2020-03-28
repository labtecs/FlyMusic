import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flymusic/music/music_queue.dart';
import 'package:flymusic/screens/settings_screen.dart';
import 'package:flymusic/screens/tabScreens/other/track_list_screen.dart';

import 'player/bottom_player_screen.dart';
import 'tabScreens/album/album_screen.dart';
import 'tabScreens/artist/artist_screen.dart';
import 'tabScreens/other/queue_screen.dart';

class StartScreen extends StatefulWidget {
  @override
  StartScreenState createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  Directory externalDirectory;
  StreamSubscription onPlayerStateChanged;

  int _page = 0;
  PageController _c;
  bool _bottomPlayerVisible = false;

  @override
  void initState() {
    _c = new PageController(
      initialPage: _page,
    );
    onPlayerStateChanged =
        MusicQueue.instance.audioPlayer.onPlayerStateChanged.listen((state) {
      if (MusicQueue.instance.currentSong != null &&
          _bottomPlayerVisible == false) {
        //make bottom player visible
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    onPlayerStateChanged.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        bottom: getAppBarBottom(),
        title: ListTile(
          title: Text(
            getTitle(),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomSettingsScreen()));
            },
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _page,
        //Add this line will fix the issue.
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          this._c.animateToPage(index,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: new Icon(Icons.audiotrack),
              title: Text(tr("songs", context: context))),
          BottomNavigationBarItem(
              icon: Icon(Icons.album),
              title: Text(tr("albums", context: context))),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text(tr("artists", context: context))),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text(tr("queue", context: context))),
        ],
      ),
      body: PageView(
        controller: _c,
        onPageChanged: (newPage) {
          setState(() {
            this._page = newPage;
          });
        },
        children: <Widget>[
          TrackList(),
          AlbumList(),
          ArtistScreen(),
          QueueScreen()
        ],
      ),
    );
  }

  PreferredSize getAppBarBottom() {
    if (MusicQueue.instance.currentSong == null) {
      return PreferredSize(
          preferredSize: Size.fromHeight(0.0), child: Container());
    }
    return PreferredSize(
        preferredSize: Size.fromHeight(65.0), child: BottomPlayer());
  }

  String getTitle() {
    switch (_page) {
      case 0:
        return tr("songs", context: context);
      case 1:
        return tr("albums", context: context);
      case 2:
        return tr("artists", context: context);
      case 3:
        return tr("queue", context: context);
      default:
        return '';
    }
  }
}

Widget emptyScreen(BuildContext context, String text) {
  return Center(
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6),
              Padding(
                padding: EdgeInsets.only(top: 18),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomSettingsScreen()));
                  },
                  color: Colors.blue,
                  child: Text(tr("settings", context: context),
                      style: Theme.of(context).textTheme.headline6),
                ),
              ),
            ],
          )));
}
