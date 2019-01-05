import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/helpers/formatters.dart';
import 'package:flutter_pk/profile/profile_dialog.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var date = Firestore.instance
        .collection(FireStoreKeys.datesCollection)
        .snapshots()
        .first;
    date.then((onValue) {
      setState(() {
        eventDate = formatDate(
          onValue.documents.first['date'],
          DateFormats.shortUiDateFormat,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
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
                child: Container(
                  height: 30.0,
                  width: 30.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(userCache.user.photoUrl),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Text(
                  widget.title,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontSize: 24.0),
                ),
                Text(eventDate)
              ],
            ),
            GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColorDark),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                ),
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}
