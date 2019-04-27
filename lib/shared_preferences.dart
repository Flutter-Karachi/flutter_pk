
import 'package:flutter_pk/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHandler {
  static Future setPreference(String key, String value) async {
    final sharedPrefsFuture = sharedPreferences;
    final waitFuture = Future.delayed(Duration(seconds: 5));
    final results = await Future.wait([sharedPrefsFuture, waitFuture]);

    final SharedPreferences prefs = results[0];
    prefs.setString(key, value);
  }

  static Future<dynamic> getValue(String key) async {
    final sharedPrefsFuture = sharedPreferences;
    final waitFuture = Future.delayed(Duration(seconds: 5));
    final results = await Future.wait([sharedPrefsFuture, waitFuture]);

    final SharedPreferences prefs = results[0];
    return prefs.get(key);
  }

  static Future clearPreferences() async {
    final sharedPrefsFuture = sharedPreferences;
    final waitFuture = Future.delayed(Duration(seconds: 5));
    final results = await Future.wait([sharedPrefsFuture, waitFuture]);

    final SharedPreferences prefs = results[0];
    prefs.clear();
  }
}