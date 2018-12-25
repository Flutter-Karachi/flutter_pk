import 'package:flutter/material.dart';
import 'package:flutter_pk/schedule/schedule_page.dart';

class HomePageMaster extends StatefulWidget {
  @override
  HomePageMasterState createState() {
    return new HomePageMasterState();
  }
}

class HomePageMasterState extends State<HomePageMaster> {
  int _selectedIndex = 0;
  List<Widget> widgets = <Widget> [
    SchedulePage(),
    Center(
      child: Text('Hello two'),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: widgets.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            title: Text('Schedule')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            title: Text('News')
          ),
        ],
      ),
    );
  }
}
