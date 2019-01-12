import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pk/caches/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Routes {
  static const String home_master = '/home_master';
  static const String main = '/main';
}

abstract class GlobalConstants {
  static const int phoneNumberMaxLength = 10;
}

abstract class SharedPreferencesKeys {
  static const String firebaseUserId = 'uid';
}

abstract class FireStoreKeys {
  static const String userCollection = 'users';
  static const String dateCollection = 'dates';
  static const String sessionCollection = 'sessions';
  static const String speakerCollection = 'speakers';
}

abstract class ColorDictionary {
  static const Map<String, Color> stringToColor = {
    'red': Colors.red,
    'green': Colors.green,
    'amber': Colors.amber,
    'blue': Colors.blue,
    'white': Colors.white,
    'black': Colors.black,
    'blueGrey': Colors.blueGrey
  };
}

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
final Future<SharedPreferences> sharedPreferences =
    SharedPreferences.getInstance();

UserCache userCache = new UserCache();
