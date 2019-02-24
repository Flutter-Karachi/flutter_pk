import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pk/feedback/feedback.dart';
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
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => FullScreenFeedbackDialog(
                      session: session,
                    ),
                fullscreenDialog: true),
          );
        },
        icon: Icon(
          Icons.rate_review,
          color: ColorDictionary.stringToColor[session.textColor],
        ),
        label: Text(
          'Feedback',
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
                    child: Center(
                      child: Text(
                          'About ${session.speakers.length > 1 ? 'speakers' : 'speaker'}'),
                    ),
                  ),
                  session.speakers.length > 1
                      ? _buildMultiSpeakerDetail()
                      : _buildSingleSpeakerDetail(),
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
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<Speaker>> _buildMultiSpeakerDetail() {
    return FutureBuilder<List<Speaker>>(
        future: _getMultiSpeakerData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var speakerOne = snapshot.data.first;
            var speakerTwo = snapshot.data[1];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: _buildSpeakerView(speakerOne)),
                Expanded(child: _buildSpeakerView(speakerTwo)),
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
        });
  }

  FutureBuilder<Speaker> _buildSingleSpeakerDetail() {
    return FutureBuilder<Speaker>(
        future: _getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildSpeakerView(snapshot.data);
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
        });
  }

  Column _buildSpeakerView(Speaker speaker) {
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
                        speaker.photoUrl,
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
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: <Widget>[
                Text(
                  speaker.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    speaker.description,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<Speaker> _getData() async {
    CollectionReference reference =
        await Firestore.instance.collection(FireStoreKeys.speakerCollection);
    var speaker =
        Speaker.fromSnapshot(await reference.document(session.speakerId).get());
    return speaker;
  }

  Future<List<Speaker>> _getMultiSpeakerData() async {
    CollectionReference reference =
        await Firestore.instance.collection(FireStoreKeys.speakerCollection);
    var speakerOne = Speaker.fromSnapshot(
        await reference.document(session.speakers[0]).get());
    var speakerTwo = Speaker.fromSnapshot(
        await reference.document(session.speakers[1]).get());
    List<Speaker> list = List<Speaker>();
    list.addAll(<Speaker>[
      speakerOne,
      speakerTwo,
    ]);
    return list;
  }
}
