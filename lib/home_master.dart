import 'package:flutter/material.dart';
import 'package:flutter_pk/dialogs/custom_error_dialog.dart';
import 'package:flutter_pk/feed.dart';
import 'package:flutter_pk/schedule/schedule_page.dart';

class HomePageMaster extends StatefulWidget {
  @override
  HomePageMasterState createState() {
    return new HomePageMasterState();
  }
}

class HomePageMasterState extends State<HomePageMaster> {
  int _selectedIndex = 0;
  List<Widget> widgets = <Widget>[
    SchedulePage(),
    Center(
      child: Text('Hello two'),
    ),
    FeedPage()
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showErrorDialog('Whoops!',
            'Registrations aren\'t opened yet!', context),
        icon: Icon(Icons.group_work),
        label: Text('Register'),
      ),
      body: widgets.elementAt(_selectedIndex),
      bottomNavigationBar:
      BottomNavigationBar(
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
}
