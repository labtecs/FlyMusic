import 'package:flutter/material.dart';

final ThemeData darkTheme = new ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  primaryColor: Colors.black54,
  buttonColor: Colors.blue,
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  textTheme: TextTheme(
    headline5: TextStyle(color: Colors.white, fontSize: 20),
    caption: TextStyle(color: Colors.white),
    bodyText2: TextStyle(color: Colors.white),
  ),
);
