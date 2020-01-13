import 'dart:io';

import 'package:dart_tags/dart_tags.dart';

class MusicFinder {
  static readFolderIntoDatabase(Directory folder) {
    //list all fields
    List<FileSystemEntity> files = new List();
    files = folder.listSync(); //use your folder name instead of resume.

    TagProcessor tp = new TagProcessor();
    for (File file in files) {
      tp
          .getTagsFromByteArray(file.readAsBytes())
          .then((l) => l.forEach((f) => print(f)));
    }
  }
}
