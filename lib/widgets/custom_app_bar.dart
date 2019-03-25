import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/helpers/formatters.dart';
import 'package:flutter_pk/profile/profile_dialog.dart';
import 'package:flutter_pk/util.dart';

class CustomAppBar extends StatefulWidget {
  final String title;
  CustomAppBar({@required this.title});
  @override
  CustomAppBarState createState() {
    return new CustomAppBarState();
  }
}

class CustomAppBarState extends State<CustomAppBar> {
  String eventDate = '';
  String eventTitle = '';
  @override
  void initState() {
    super.initState();
    var eventDetails = Firestore.instance
        .collection(FireStoreKeys.dateCollection)
        .snapshots()
        .first;
    eventDetails.then((onValue) {
      setState(() {
        eventDate = formatDate(
          toDateTime(onValue.documents.first['date']),
          DateFormats.shortUiDateFormat,
        );
        eventDateTimeCache
            .setDateTime(toDateTime(onValue.documents.first['date']));
        eventTitle = onValue.documents.first['eventTitle'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 40, right: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullScreenProfileDialog(),
                  fullscreenDialog: true,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(userCache.user.photoUrl)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                eventTitle,
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
              ),
              Text(eventDate)
            ],
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }
}
