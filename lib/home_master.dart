import 'package:flutter/material.dart';
import 'package:flutter_pk/feed.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/helpers/regex-helpers.dart';
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
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
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
        onPressed: () {
          showRoundedModalBottomSheet(
              radius: 20.0,
              context: context,
              builder: (context) {
                return SafeArea(
                  child: userCache.user.mobileNumber == null
                      ? _buildAddNumberSheet(context)
                      : _buildEditNumberSheet(context),
                );
              });
        },
        icon: Icon(Icons.group_work),
        label: Text('Register'),
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

  Column _buildEditNumberSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Looks like you have a number registered against your account. You can use the same number to receive event confirmations or you can update it.',
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.subhead,
          ),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text(userCache.user.mobileNumber),
          trailing: Icon(Icons.edit),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () {},
                  child: Text(
                    'Register!',
                    style: Theme.of(context).textTheme.subhead.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Column _buildAddNumberSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Enter your phone number so that you can receive SMS updates regarding the event.',
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.subhead,
          ),
        ),
        Form(
          key: _formKey,
          child: ListTile(
            title: TextFormField(
              maxLength: GlobalConstants.phoneNumberMaxLength,
              validator: (value) => _validatePhoneNumber(value),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  prefixIcon: Padding(
                    child: Text('+92'),
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      left: 16.0,
                    ),
                  ),
                  hintText: 'Enter mobile number',
                  labelText: 'Mobile number'),
            ),
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {}
                  },
                  child: Text(
                    'Register!',
                    style: Theme.of(context).textTheme.subhead.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  String _validatePhoneNumber(String number) {
    if (number.isEmpty) return 'Phone number required';
    if (number.length < GlobalConstants.phoneNumberMaxLength ||
        !RegexHelpers.phoneNumberRegex.hasMatch(number))
      return 'You wouldn\'t want to miss any important update! \nPlease enter a valid mobile number';
  }
}
