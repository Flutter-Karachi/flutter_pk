import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pk/caches/user.dart';
import 'package:flutter_pk/global.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginApi {
  Future<String> initiateLogin() async {
    var user = await signInWithGoogle();

    await _setUserToFireStore(user.user!);

    return user.user!.uid;
  }

  Future<UserCredential> signInWithGoogle() async {

    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await (GoogleSignIn().signIn() as Future<GoogleSignInAccount>);

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    ) as GoogleAuthCredential;

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future _setUserToFireStore(User user) async {
    CollectionReference reference =
    FirebaseFirestore.instance.collection(FireStoreKeys.userCollection);

    await reference.doc(user.uid).get().then((snap) async {
      if (!snap.exists) {
        InAppUser _user = InAppUser(
            name: user.displayName,
            mobileNumber: user.phoneNumber,
            id: user.uid,
            photoUrl: user.photoURL,
            email: user.email);

        await reference
            .doc(user.uid)
            .set(_user.toJson(), SetOptions(merge: true));
      }
    });
  }

  Future<GoogleSignInAuthentication> _handleGoogleSignIn() async {
    GoogleSignInAccount googleUser = await (googleSignIn.signIn() as Future<GoogleSignInAccount>);
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    return googleAuth;
  }

//  initialize() {
//    Firestore.instance.settings(
//        // TODO: Update this according to the new implementation
////      timestampsInSnapshotsEnabled: true,
//        );
//  }
}
