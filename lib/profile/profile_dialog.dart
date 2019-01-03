import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pk/global.dart';

class FullScreenProfileDialog extends StatefulWidget {
  @override
  FullScreenProfileDialogState createState() {
    return new FullScreenProfileDialogState();
  }
}

class FullScreenProfileDialogState extends State<FullScreenProfileDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildCustomAppBarSpace(context),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Padding _buildCustomAppBarSpace(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              child: Icon(Icons.clear),
              onTap: () => Navigator.of(context).pop(),
            ),
            GestureDetector(
              child: Text(
                'SIGN OUT',
                style: Theme.of(context).textTheme.subhead.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              onTap: () async {
                await googleSignIn.signOut();
                await auth.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.main,
                  ModalRoute.withName(Routes.home_master),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 70.0,
                width: 70.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(userCache.user.photoUrl),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  userCache.user.name,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: Colors.grey),
                ),
              ),
              Text(
                userCache.user.email,
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: Colors.black38),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: Image(
                    image: AssetImage('assets/loader.png'),
                  ),
                  height: 70.0,
                  width: 70.0,
                ),
                Center(
                  child: Text(
                    'More features coming soon!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.black38),
                  ),
                ),
              ],
            ),
          ),
          Text('Built with Flutter & Material'),
        ],
      ),
    );
  }
}
