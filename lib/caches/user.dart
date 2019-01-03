import 'package:cloud_firestore/cloud_firestore.dart';

class UserCache {
  User _user;

  User get user => _user;

  Future<User> getCurrentUser(String id) async {
    if (_user != null) {
      return _user;
    }
    _user = User.fromSnapshot(
        await Firestore.instance.collection('users').document(id).get());
    return _user;
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String mobileNumber;
  final bool isRegistered;
  final DocumentReference reference;

  User({
    this.name,
    this.id,
    this.email,
    this.reference,
    this.photoUrl,
    this.isRegistered = false,
    this.mobileNumber,
  });

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map['id'],
        name = map['name'],
        email = map['email'],
        photoUrl = map['photoUrl'],
        isRegistered = map['isRegistered'],
        mobileNumber = map['mobileNumber'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "photoUrl": photoUrl,
        "isRegistered": isRegistered,
        "mobileNumber": mobileNumber,
      };

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
