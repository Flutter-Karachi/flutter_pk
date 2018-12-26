import 'package:flutter/material.dart';
import 'package:flutter_pk/global.dart';
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
            Text(
              widget.title,
              style: Theme.of(context).textTheme.title.copyWith(fontSize: 24.0),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                height: 30.0,
                width: 30.0,
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
