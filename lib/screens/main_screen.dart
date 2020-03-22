import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flymusic/database/model/art.dart';
import 'package:flymusic/database/model/song.dart';
import 'package:flymusic/main.dart';
import 'package:flymusic/music/music_finder.dart';
import 'package:folder_picker/folder_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'drawerScreens/drawer_screen.dart';
import 'tabScreens/album/album_screen.dart';
import 'tabScreens/track_list_screen.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();

  static FutureBuilder getArt(int artId) {
    return FutureBuilder<Art>(
        future: database.artDao.findArtById(artId),
        builder: (BuildContext context, AsyncSnapshot<Art> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Image.file(File(snapshot.data.path), fit: BoxFit.cover);
          } else {
            return Image(image: AssetImage("asset/images/placeholder.jpg"));
          }
        });
  }

  static FutureBuilder getArt2(Song song) {
    return FutureBuilder<Art>(
        future: database.artDao.findArtById(song?.artId ?? -1),
        builder: (BuildContext context, AsyncSnapshot<Art> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return DrawerHeader(
              child: Text(
                song?.title ?? "",
                //style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                  //color: Colors.blue,
                  image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: Image.file(File(snapshot.data.path)).image)),
            );
            //  return MemoryImage(File(snapshot.data.path));
          } else {
            return DrawerHeader(
              child: Text(
                song?.title ?? "",
                //style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                  //color: Colors.blue,
                  image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: ExactAssetImage("asset/images/placeholder.jpg"))),
            );
          }
        });

  }  static FutureBuilder getArt3(Song song) {
    return FutureBuilder<Art>(
        future: database.artDao.findArtById(song?.artId ?? -1),
        builder: (BuildContext context, AsyncSnapshot<Art> snapshot) {
          try {
            if (snapshot.hasData && snapshot.data != null) {
              return Image.asset(snapshot.data.path);
            } else {
              return Image.asset("asset/images/placeholder.jpg",);
            }
          }
          catch(q) {
            //should never be used
            print("Bild konnte nicht geladen werden: " + snapshot.data.path);
            return Image.asset("asset/images/placeholder.jpg",);
          }
        });
  }
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  Directory externalDirectory;
  TabController _tabController;

  int _page = 0;
  PageController _c;

  @override
  void initState() {
    _c = new PageController(
      initialPage: _page,
    );
    super.initState();
  }

  /**
   * Scaffold
   * - Drawer
   * - AppBar
   * - bottomNaviaationBar
   * - PageView
   */
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        title: ListTile(
          title: Text(getTitle(), style: Theme.of(context).textTheme.headline,
          ),
        ),
        //backgroundColor: Colors.black54,

      ),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _page,
        onTap: (index){
          this._c.animateToPage(index,duration: const Duration(milliseconds: 500),curve: Curves.easeInOut);
        },
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(icon: new Icon(Icons.audiotrack), title: new Text("Tracks")),
          new BottomNavigationBarItem(icon: new Icon(Icons.album), title: new Text("Albums")),
          new BottomNavigationBarItem(icon: new Icon(Icons.person), title: new Text("Artists")),

        ],

      ),
      body: new PageView(
        controller: _c,
        onPageChanged: (newPage){
          setState((){
            this._page=newPage;
          });
        },
        children: <Widget>[
          TrackList(),
          AlbumList(),
          AlbumList(),
        ],
      ),
      // bottomSheet: BottomPlayer(),
    );
  }

  /**
   *
   */
  Future<void> chooseFolder() async {
    var result =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (result[PermissionGroup.storage] == PermissionStatus.granted) {
      //  await getStorage();
      Navigator.of(context).push<FolderPickerPage>(
          MaterialPageRoute(builder: (BuildContext context) {
        return FolderPickerPage(
            rootDirectory: Directory("/storage/emulated/0/"),

            /// a [Directory] object
            action: (BuildContext context, Directory folder) async {
              Navigator.of(context).pop();
              MusicFinder.instance.readFolderIntoDatabase(folder);
            });
      }));
    }
  }

  /**
   * Gibt den Namen der Tabs zurück.
   */
  String getTitle() {
    switch (_page) {
      case 0:
        return 'Lied Liste';
      case 1:
        return 'Alben';
      case 2:
        return 'Künstler';
      default:
        return '';
    }
  }

  void onTapped(index)  {
    setState(() {
      _page = index;
    });
  }
}
