import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pk/caches/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class Routes {
  static const String home_master = '/home_master';
  static const String main = '/main';
}

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;

UserCache userCache = new UserCache();