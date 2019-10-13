import 'package:flutter_pk/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHandler {
  SharedPreferences _prefs;
  Future<SharedPreferences> get prefs async {
    if (_prefs == null) {
      _prefs = await sharedPreferences;
    }

    return _prefs;
  }

  Future setPreference(String key, String value) async {
    await prefs.then((item) {
      item.setString(key, value);
    });
  }

  Future<dynamic> getValue(String key) async {
    return await prefs.then((item) {
      return item.get(key);
    });
  }

  Future clearPreferences() async {
    await prefs.then((item) {
      item.clear();
    });
  }
}
