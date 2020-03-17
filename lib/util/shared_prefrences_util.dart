import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static SharedPreferencesUtil _storageUtil;
  static SharedPreferences _preferences;

  static Future getInstance() async {
    if (_storageUtil == null) {
      // keep local instance till it is fully initialized.
      var secureStorage = SharedPreferencesUtil._();
      await secureStorage._init();
      _storageUtil = secureStorage;
    }
    return _storageUtil;
  }

  SharedPreferencesUtil._();

  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  getString(PrefKey prefKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return prefs.getString(prefKey.index.toString());
  }

  setString(PrefKey prefKey, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return await prefs.setString(prefKey.index.toString(), value);
  }

  getBool(PrefKey prefKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return prefs.getBool(prefKey.index.toString());
  }

  static Future<List<String>> getList(PrefKey prefKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return prefs.getString(prefKey.index.toString())?.split("##") ?? List<String>();
  }

  setBool(PrefKey prefKey, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return await prefs.setBool(prefKey.index.toString(), value);
  }

  getInt(PrefKey prefKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return prefs.getInt(prefKey.index.toString());
  }

  setInt(PrefKey prefKey, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return await prefs.setInt(prefKey.index.toString(), value);
  }

  getDouble(PrefKey prefKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return prefs.getDouble(prefKey.index.toString());
  }

  setDouble(PrefKey prefKey, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return await prefs.setDouble(prefKey.index.toString(), value);
  }

  static setList(PrefKey prefKey, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    return await prefs.setString(prefKey.index.toString(), value.join('##'));
  }
}


enum PrefKey{
  SONG_SHORT_PRESS, SONG_LONG_PRESS, SONG_ACTION_BUTTON,
  ALBUM_SHORT_PRESS, ALBUM_LONG_PRESS, ALBUM_ACTION_BUTTON,
  SHOW_POPUP, PATH_LIST
}