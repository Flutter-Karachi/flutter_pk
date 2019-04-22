

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pk/caches/user.dart';
import 'package:flutter_pk/global.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  Future<String> handleGoogleSignIn() async {

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    CollectionReference reference =
    Firestore.instance.collection(FireStoreKeys.userCollection);

    await reference.document(user.uid).get().then((snap) async {
      if (!snap.exists) {
        User _user = User(
            name: user.displayName,
            mobileNumber: user.phoneNumber,
            id: user.uid,
            photoUrl: user.photoUrl,
            email: user.email);

        await reference
            .document(user.uid)
            .setData(_user.toJson(), merge: true);
      }
    });
    return user.uid;
  }

  setTimestampsSnapshots() {
    Firestore.instance.settings(
    timestampsInSnapshotsEnabled: true,
    );
  }

}