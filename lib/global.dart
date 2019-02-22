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
  static const int phoneNumberMaxLength = 13;
  static const int entryMaxLength = 50;
  static const String qrKey = "thisisahighlyencryptedaubykhanstringthatisbeingusedforfluttermeetupqrscan";
  static const String addNumberDisplayText =
      'Add your phone number in order to receive event updates.';
  static const String editNumberDisplayText =
      'Looks like you have a number registered against your account. You can use the same number to receive event confirmations or you can update it.';
}

abstract class SharedPreferencesKeys {
  static const String firebaseUserId = 'uid';
}

abstract class FireStoreKeys {
  static const String userCollection = 'users';
  static const String dateCollection = 'dates';
  static const String sessionCollection = 'sessions';
  static const String speakerCollection = 'speakers';
  static const String attendanceCollection = 'attendance';
  static const String attendeesCollection = 'attendees';
  static const String dateReferenceString = '16032019';
}

abstract class ColorDictionary {
  static const Map<String, Color> stringToColor = {
    'indigo': Colors.indigo,
    'green': Colors.green,
    'amber': Colors.amber,
    'blue': Colors.blue,
    'white': Colors.white,
    'black': Colors.black,
    'blueGrey': Colors.blueGrey,
    'lightBlue': Colors.lightBlue,
    'brown': Colors.brown,
    'teal': Colors.teal,
    'indigoAccent': Colors.indigoAccent
  };
}

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
final Future<SharedPreferences> sharedPreferences =
    SharedPreferences.getInstance();

UserCache userCache = new UserCache();
