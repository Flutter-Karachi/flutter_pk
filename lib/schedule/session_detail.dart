import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/schedule/model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SessionDetailPage extends StatelessWidget {
  final Session session;
  SessionDetailPage({@required this.session});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          session.title,
          style: TextStyle(
              color: ColorDictionary.stringToColor[session.textColor]),
        ),
        backgroundColor: ColorDictionary.stringToColor[session.color],
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 40.0,
            ),
            color: ColorDictionary.stringToColor[session.textColor],
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: Icon(
          Icons.rate_review,
          color: ColorDictionary.stringToColor[session.textColor],
        ),
        label: Text(
          'Rate',
          style: TextStyle(
              color: ColorDictionary.stringToColor[session.textColor]),
        ),
        backgroundColor: ColorDictionary.stringToColor[session.color],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Center(child: Text('About speaker')),
                  ),
                  FutureBuilder<Speaker>(
                      future: _getData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Center(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 70.0,
                                        width: 70.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(
                                              'assets/ic_person.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 70.0,
                                        width: 70.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              snapshot.data.photoUrl,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Text(
                                          snapshot.data.description,
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: Text(
                              'Fetching speaker details',
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(color: Colors.grey),
                            ),
                          );
                        }
                      }),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorDictionary.stringToColor[session.color],
                          borderRadius: BorderRadius.circular(10.0)),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Center(
                            child: Text(
                              session.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorDictionary
                                    .stringToColor[session.textColor],
                              ),
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 8.0),
                          child: Text(
                            session.description,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: ColorDictionary
                                    .stringToColor[session.textColor]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60.0,
                  )
                ],
              ),
            ),
//            ListTile(
//                title: FutureBuilder<String>(
//              future: _getData(),
//              builder: (context, snapshot) {
//                if (snapshot.hasData) {
//                  return Text(
//                    snapshot.data.toString(),
//                    textAlign: TextAlign.center,
//                    overflow: TextOverflow.ellipsis,
//                    style: TextStyle(fontWeight: FontWeight.bold),
//                  );
//                } else if (snapshot.hasError) {
//                  return Text("${snapshot.error}");
//                }
//
//                return new CircularProgressIndicator();
//              },
//            )),
          ],
        ),
      ),
    );
  }

  Future<Speaker> _getData() async {
    CollectionReference reference =
        await Firestore.instance.collection(FireStoreKeys.speakerCollection);
    var speaker =
        Speaker.fromSnapshot(await reference.document(session.speakerId).get());
    return speaker;
  }
}

class Speaker {
  final String id;
  final String name;
  final String photoUrl;
  final String description;
  final DocumentReference reference;

  Speaker({
    this.name,
    this.id,
    this.description,
    this.reference,
    this.photoUrl,
  });

  Speaker.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map['id'],
        description = map['description'],
        name = map['name'],
        photoUrl = map['photoUrl'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
      };

  Speaker.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
