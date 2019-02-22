import 'package:flutter/material.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/helpers/formatters.dart';
import 'package:flutter_pk/schedule/model.dart';
import 'package:flutter_pk/schedule/session_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pk/widgets/custom_app_bar.dart';

class SchedulePage extends StatefulWidget {
  @override
  SchedulePageState createState() {
    return new SchedulePageState();
  }
}

class SchedulePageState extends State<SchedulePage>
    with SingleTickerProviderStateMixin {
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
      child: _streamBuilder(FireStoreKeys.sessionCollection),
    );
  }

  StreamBuilder<QuerySnapshot> _streamBuilder(String parameter) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(FireStoreKeys.dateCollection)
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
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
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
                  color: ColorDictionary.stringToColor[session?.color],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    session.title,
                    style: TextStyle(
                        color:
                            ColorDictionary.stringToColor[session?.textColor]),
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
                      color: ColorDictionary.stringToColor[session?.textColor],
                    ),
                  ),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SessionDetailPage(
                              session: session,
                            ),
                      ),
                    );
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
