import 'package:flutter/material.dart';


final ThemeData darkTheme = new ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: Colors.black54,
    buttonColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    textTheme: TextTheme(
        headline: TextStyle(color: Colors.white, fontSize: 20),
      caption: TextStyle(color: Colors.white),
      body1: TextStyle(color: Colors.white),
    ),
);
