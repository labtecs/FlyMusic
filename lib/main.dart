import 'package:flutter/material.dart';
import 'package:flymusic/database/moor_database.dart';
import 'package:flymusic/screens/main_screen.dart';
import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  // create a moor executor in a new background isolate. If you want to start the isolate yourself, you
  // can also call MoorIsolate.inCurrent() from the background isolate
 // MoorIsolate isolate = await MoorIsolate.spawn(backgroundConnection);

  // we can now create a database connection that will use the isolate internally. This is NOT what's
  // returned from _backgroundConnection, moor uses an internal proxy class for isolate communication.
//  DatabaseConnection connection = await isolate.connect();

 // final db = AppDatabase.connect(connection);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

//how this isolate works in detail https://moor.simonbinder.eu/docs/advanced-features/isolates/

// This needs to be a top-level method because it's run on a background isolate
DatabaseConnection backgroundConnection() {
  // construct the database. You can also wrap the VmDatabase in a "LazyDatabase" if you need to run
  // work before the database opens.
  final database = VmDatabase.memory();
  return DatabaseConnection.fromExecutor(database);
}

class MyApp extends StatelessWidget {
  static final db  = AppDatabase();

  MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (_) => db.songDao),
          Provider(create: (_) => db.albumDao),
          Provider(create: (_) => db.artistDao),
          Provider(create: (_) => db.artDao),
          Provider(create: (_) => db.queueItemDao),
        ],
        child: MaterialApp(
          title: 'Fly Music',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: StartScreen(),
        ));
  }
}
