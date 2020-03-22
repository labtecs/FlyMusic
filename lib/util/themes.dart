import 'package:flutter/material.dart';

ThemeData basicTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
      headline: base.headline.copyWith(
        fontFamily: 'MerriWeather',
        fontSize: 20.0,
        color: Colors.white,
      ),
      display1: base.title.copyWith(
        fontFamily: 'asdf',
        color: Colors.white,
      ),
    );
  }
  final ThemeData base=ThemeData.light();
  return base.copyWith(
    textTheme: _basicTextTheme(base.textTheme),
    primaryColor: Color.fromARGB(255, 47 , 114, 222),
  );
}
