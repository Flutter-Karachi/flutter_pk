import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pk/caches/user.dart';
import 'package:flutter_pk/feed.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/helpers/regex-helpers.dart';
import 'package:flutter_pk/registration/registration.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:flutter_pk/schedule/schedule_page.dart';

class HomePageMaster extends StatefulWidget {
  @override
  HomePageMasterState createState() {
    return new HomePageMasterState();
  }
}

class HomePageMasterState extends State<HomePageMaster> {
  int _selectedIndex = 0;
  User _user = new User();
  List<Widget> widgets = <Widget>[
    SchedulePage(),
    Center(
      child: Text('Hello two'),
    ),
    FeedPage()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setUser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _user.isRegistered
            ? Alert(
                context: context,
                type: AlertType.info,
                title: "Information!",
                desc:
                    "You will be able to scan a QR on the event day!\nCheers!",
                buttons: [
                  DialogButton(
                    child: Text("Cool!",
                        style: Theme.of(context).textTheme.title.copyWith(
                              color: Colors.white,
                            )),
                    color: Colors.green,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ).show()
            : _navigateToRegistration(context),
        icon: Icon(
            _user.isRegistered ? Icons.center_focus_weak : Icons.group_work),
        label: Text(_user.isRegistered ? 'Scan QR' : 'Register'),
      ),
      body: widgets.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          if (value != 1)
            setState(() {
              _selectedIndex = value;
            });
        },
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.date_range), title: Text('Schedule')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.date_range,
                color: Colors.transparent,
              ),
              title: Text(' ')),
          BottomNavigationBarItem(
              icon: Icon(Icons.rss_feed), title: Text('Feed')),
        ],
      ),
    );
  }

  Future _navigateToRegistration(BuildContext context) async {
    {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RegistrationPage(),
          fullscreenDialog: true,
        ),
      );
      var user =
          await userCache.getCurrentUser(userCache.user.id, useCached: false);
      setState(() {
        _user = user;
      });
    }
  }

  Future _setUser() async {
    var user = await userCache.getCurrentUser(userCache.user.id);
    setState(() {
      _user = user;
    });
  }
}
