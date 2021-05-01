import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pk/caches/user.dart';
import 'package:flutter_pk/contribution/contribution_dialog.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/helpers/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FullScreenProfileDialog extends StatefulWidget {
  @override
  FullScreenProfileDialogState createState() {
    return new FullScreenProfileDialogState();
  }
}

class FullScreenProfileDialogState extends State<FullScreenProfileDialog> {
  InAppUser? _user = new InAppUser();
  late SharedPreferencesHandler preferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preferences = SharedPreferencesHandler();
    _setUser();
  }

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
                style: Theme.of(context).textTheme.subhead!.copyWith(
                      color: Theme.of(context).accentColor,
                    ),
              ),
              onTap: () async {
                try {
                  await googleSignIn.signOut();
                  await auth.signOut();
                  preferences.clearPreferences();
                  userCache.clear();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.main,
                    ModalRoute.withName(Routes.home_master),
                  );
                } catch (ex) {
                  print(ex);
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "Oops!",
                    desc: "An error has occurred",
                    buttons: [
                      DialogButton(
                        child: Text("Dismiss",
                            style: Theme.of(context).textTheme.title!.copyWith(
                                  color: Colors.white,
                                )),
                        color: Colors.red,
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ).show();
                }
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
                    image: NetworkImage(_user!.photoUrl!),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _user!.name!,
                  style: Theme.of(context)
                      .textTheme
                      .title!
                      .copyWith(color: Colors.grey),
                ),
              ),
              Text(
                _user!.email!,
                style: Theme.of(context)
                    .textTheme
                    .subhead!
                    .copyWith(color: Colors.black38),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              'You can provide session feedback after the event day ends.',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[],
            ),
          ),
          !_user!.isContributor!
              ? ListTile(
                  title: Center(child: Text('Want to contribute?')),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FullScreenContributionDialog(),
                        fullscreenDialog: true,
                      ),
                    );
                    var user = await userCache.getUser(
                      userCache.user!.id,
                      useCached: false,
                    );
                    Timer(Duration(seconds: 2), () {
                      setState(() {
                        _user = user;
                      });
                      _setUser();
                    });
                  },
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: SizedBox(
              height: 50.0,
              child: Image(
                image: AssetImage('assets/feature.png'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Built with Flutter & Material'),
          ),
        ],
      ),
    );
  }

  Future _setUser() async {
    var user = await userCache.getUser(userCache.user!.id);
    setState(() {
      _user = user;
    });
  }
}
