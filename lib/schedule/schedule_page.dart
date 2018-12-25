import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  @override
  SchedulePageState createState() {
    return new SchedulePageState();
  }
}

class SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildCustomAppBarSpace(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBarSpace() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.email),
            ),
            Text(
              'Schedule',
              style: Theme.of(context).textTheme.title.copyWith(fontSize: 24.0),
            ),
            Switch(
              onChanged: (value) {},
              value: true,
            )
          ],
        ),
      ),
    );
  }
}
