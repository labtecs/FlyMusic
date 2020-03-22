import 'package:flutter/material.dart';

ThemeData basicTheme() {
  TextTheme _basicTextTeme(TextTheme base) {
    return base.copyWith(
      headline: base.headline.copyWith(
        fontFamily: 'MerriWeather',
        fontSize: 20.0,
        color: Colors.white,
      )
    );
  }
  final ThemeData base=ThemeData.light();
  return base.copyWith(
    textTheme: _basicTextTeme(base.textTheme),
    primaryColor: Color.fromARGB(255, 47 , 114, 222),
  );
}
