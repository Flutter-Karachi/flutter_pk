import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pk/global.dart';

class FullScreenContributionDialog extends StatefulWidget {
  @override
  FullScreenContributionDialogState createState() {
    return new FullScreenContributionDialogState();
  }
}

class FullScreenContributionDialogState
    extends State<FullScreenContributionDialog> {
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
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: FlatButton(
              child: Text('SKIP'),
              color: Colors.transparent,
              textColor: Colors.transparent,
              onPressed: () {},
            ),
          ),
          Text('Community contribution'),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text(
                  'SKIP',
                  style: Theme.of(context).textTheme.subhead.copyWith(
                        color: Colors.grey,
                      ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.tab,
                      color: Theme.of(context).primaryColor,
                      size: 80.0,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24.0, left: 16.0),
                      child: Image(
                        image: AssetImage(
                          'assets/flutterKarachi.png',
                        ),
                        height: 40.0,
                        width: 40.0,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.desktop_mac,
                        color: Theme.of(context).primaryColor,
                        size: 150.0,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 28.0, left: 42.0),
                        child: Image(
                          image: AssetImage(
                            'assets/flutterKarachi.png',
                          ),
                          height: 60.0,
                          width: 60.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.phone_iphone,
                      color: Theme.of(context).primaryColor,
                      size: 80.0,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 19.0),
                      child: Image(
                        image: AssetImage(
                          'assets/flutterKarachi.png',
                        ),
                        height: 40.0,
                        width: 40.0,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'In what capacity do you want to contribute to the Flutter community?',
              style: Theme.of(context).textTheme.title,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                CheckboxListTile(
                  title: Text('Volunteer'),
                  value: true,
                  onChanged: (bool value) {},
                ),
                CheckboxListTile(
                  title: Text('Administration & Logistics'),
                  value: false,
                  onChanged: (bool value) {},
                ),
                CheckboxListTile(
                  title: Text('Speaker'),
                  value: true,
                  onChanged: (bool value) {},
                ),
                CheckboxListTile(
                  title: Text('Social media marketing'),
                  value: false,
                  onChanged: (bool value) {},
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text('CONTINUE'),
                          Icon(
                            Icons.arrow_forward,
                            size: 24.0,
                          )
                        ],
                      ),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {},
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
