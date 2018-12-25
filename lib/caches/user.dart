
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pk/global.dart';

class UserCache {
  FirebaseUser _user;

  FirebaseUser get user => _user;

  Future<FirebaseUser> getCurrentUser() async {
    if (_user != null) {
      return _user;
    }
    _user = await auth.currentUser();
    return _user;
  }
}