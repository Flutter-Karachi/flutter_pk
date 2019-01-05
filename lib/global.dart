import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pk/caches/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Routes {
  static const String home_master = '/home_master';
  static const String main = '/main';
}

abstract class SharedPreferencesKeys {
  static const String firebaseUserId = 'uid';
}

abstract class FireStoreKeys {
  static const String userCollection = 'users';
  static const String datesCollection = 'dates';
  static const String sessionsCollection = 'sessions';
}

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
final Future<SharedPreferences> sharedPreferences =
    SharedPreferences.getInstance();

UserCache userCache = new UserCache();
