import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static final SharedPreferencesUtil instance =
      SharedPreferencesUtil._internal();

  factory SharedPreferencesUtil() => instance;

  SharedPreferencesUtil._internal();

  getString(PrefKey prefKey) async {
    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return prefs.getString(prefKey.index.toString());
    */
    return "1";
  }

  setString(PrefKey prefKey, String value) async {
    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return await prefs.setString(prefKey.index.toString(), value);
    */
    return "1";
  }

  getBool(PrefKey prefKey) async {
    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return prefs.getBool(prefKey.index.toString());
    */
    return true;
  }

  static Future<List<String>> getList(PrefKey prefKey) async {
    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return prefs.getString(prefKey.index.toString())?.split("##") ??
        List<String>();
    */
    return List();
  }

  setBool(PrefKey prefKey, bool value) async {
    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return await prefs.setBool(prefKey.index.toString(), value);
    */
    return true;
  }

  getInt(PrefKey prefKey) async {
    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return prefs.getInt(prefKey.index.toString());
    */
    return 1;
  }

  setInt(PrefKey prefKey, int value) async {
    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return await prefs.setInt(prefKey.index.toString(), value);
    */
    return 1;
  }

  getDouble(PrefKey prefKey) async {
    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return prefs.getDouble(prefKey.index.toString());
    */
    return 1.0;
  }

  setDouble(PrefKey prefKey, double value) async {
    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return await prefs.setDouble(prefKey.index.toString(), value);
    */
    return 1.0;
  }

  static setList(PrefKey prefKey, List<String> value) async {
    /*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return await prefs.setString(prefKey.index.toString(), value.join('##'));
    */
    return false;
  }
}

enum PrefKey {
  FIRST_APP_START,
  PATH_LIST,
  SONG_SHORT_PRESS,
  SONG_LONG_PRESS,
  SONG_ACTION_BUTTON,
  QUEUE_CLEAR_OPTION,
  QUEUE_WARNING_ON_CLEAR,
  QUEUE_INSERT_OPTION
}
