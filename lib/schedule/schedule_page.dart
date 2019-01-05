import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/helpers/formatters.dart';
import 'package:flutter_pk/widgets/capsule_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pk/widgets/custom_app_bar.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rounded_modal/rounded_modal.dart';

class SchedulePage extends StatefulWidget {
  @override
  SchedulePageState createState() {
    return new SchedulePageState();
  }
}

class SchedulePageState extends State<SchedulePage>
    with SingleTickerProviderStateMixin {
  final Map<String, Color> _stringToColor = {
    'red': Colors.red,
    'green': Colors.green,
    'amber': Colors.amber,
    'blue': Colors.blue,
    'white': Colors.white,
    'black': Colors.black,
    'blueGrey' : Colors.blueGrey
  };

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title: 'Schedule',
            ),
            _buildBody()
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: _streamBuilder(FireStoreKeys.sessionsCollection),
    );
  }

  StreamBuilder<QuerySnapshot> _streamBuilder(String parameter) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(FireStoreKeys.datesCollection)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: Text(
              'Nothing found!',
              style: Theme.of(context).textTheme.title.copyWith(
                    color: Colors.black26,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          );
        return _getCollection(
            context, snapshot.data.documents?.first, parameter);
      },
    );
  }

  Widget _getCollection(
      BuildContext context, DocumentSnapshot snapshot, String parameter) {
    return StreamBuilder<QuerySnapshot>(
        stream: snapshot.reference
            .collection(parameter)
            .orderBy('startDateTime')
            .snapshots(),
        builder: (context, snapshot) {
          return _buildList(context, snapshot.data?.documents);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    if (snapshot == null) return Container();
    if (snapshot.length < 1) return Container();
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot
          .map((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final session = Session.fromSnapshot(data);
    var hour = session.startDateTime?.hour;
    var minute = session.startDateTime?.minute;

    if (hour == null || minute == null)
      return Center(
        child: Text(
          'Nothing found!',
          style: Theme.of(context).textTheme.title.copyWith(
                color: Colors.black26,
                fontWeight: FontWeight.bold,
              ),
        ),
      );

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                children: <Widget>[
                  Text(
                    '${hour < 10 ? '0' + hour.toString() : hour.toString()}:${minute < 10 ? '0' + minute.toString() : minute.toString()}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'HRS',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _stringToColor[session?.color],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    session.title,
                    style: TextStyle(color: _stringToColor[session?.textColor]),
                  ),
                  subtitle: Text(
                    '${formatDate(
                      session?.startDateTime,
                      DateFormats.shortUiDateTimeFormat,
                    )} - ${formatDate(
                      session?.endDateTime,
                      DateFormats.shortUiTimeFormat,
                    )}',
                    style: TextStyle(
                      color: _stringToColor[session?.textColor],
                    ),
                  ),
                  onTap: () {
                    showRoundedModalBottomSheet(
                        context: context,
                        autoResize: true,
                        radius: 20.0,
                        color: Theme.of(context).canvasColor,
                        builder: (context) => Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      session.title,
                                      overflow: TextOverflow.clip,
                                      softWrap: true,
                                    ),
                                    trailing: RaisedButton(
                                      onPressed: () {},
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      color: _stringToColor[session.color],
                                      textColor:
                                          _stringToColor[session.textColor],
                                      child: Text('Rate this session'),
                                    ),
                                  ),
                                  ListTile(
                                    subtitle: Center(
                                        child: Text(session.description)),
                                  ),
                                ],
                              ),
                            ));
                  },
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
        )
      ],
    );
  }
}

class Session {
  final String title;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String color;
  final String textColor;
  final String description;
  final DocumentReference reference;

  Session({
    this.title,
    this.endDateTime,
    this.startDateTime,
    this.color,
    this.textColor,
    this.description,
    this.reference,
  });

  Session.fromMap(Map<String, dynamic> map, {this.reference})
      : title = map['title'],
        endDateTime = map['endDateTime'],
        startDateTime = map['startDateTime'],
        color = map['color'],
        textColor = map['textColor'],
        description = map['description'];

  Session.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
