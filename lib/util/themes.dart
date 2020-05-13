import 'package:flutter/material.dart';

enum ThemeType { Light, Dark, Auto }

class ThemeModel extends ChangeNotifier {
  ThemeData currentThemeLight = lightTheme();
  ThemeData currentThemeDark = darkTheme();
  ThemeType _themeType = ThemeType.Auto;

  setTheme(ThemeType themeType) {
    _themeType = themeType;

    switch (_themeType) {
      case ThemeType.Auto:
        currentThemeLight = lightTheme();
        currentThemeDark = darkTheme();
        break;
      case ThemeType.Light:
        currentThemeLight = lightTheme();
        currentThemeDark = lightTheme();
        break;
      case ThemeType.Dark:
        currentThemeLight = darkTheme();
        currentThemeDark = darkTheme();
        break;
    }
    notifyListeners();
  }
}

ThemeData lightTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
      headline5: base.headline5.copyWith(
        fontFamily: 'MerriWeather',
        fontSize: 20.0,
        color: Colors.black,
      ),
      headline4: base.headline4.copyWith(
        fontFamily: 'FontFamily2',
        color: Colors.black,
      ),
    );
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
    backgroundColor: Colors.white70,
    brightness: Brightness.light,
    textTheme: _basicTextTheme(base.textTheme),
    primaryColor: Colors.indigo,
  );
}

ThemeData darkTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
      headline5: base.headline5.copyWith(
        fontFamily: 'MerriWeather',
        fontSize: 20.0,
        color: Colors.white70,
      ),
      headline4: base.headline4.copyWith(
        fontFamily: 'FontFamily2',
        color: Colors.white70,
      ),
    );
  }

  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    brightness: Brightness.dark,
    backgroundColor: Colors.black38,
    textTheme: _basicTextTheme(base.textTheme),
    primaryColor: Colors.black,
  );
}
