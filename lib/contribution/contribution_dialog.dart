import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pk/global.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FullScreenContributionDialog extends StatefulWidget {
  @override
  FullScreenContributionDialogState createState() {
    return new FullScreenContributionDialogState();
  }
}

class FullScreenContributionDialogState
    extends State<FullScreenContributionDialog> {
  bool? _isVolunteer = false;
  bool? _isLogisticsAdministrator = false;
  bool? _isSpeaker = false;
  bool? _isSocialMediaMarketingPerson = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
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
                  style: Theme.of(context).textTheme.subhead!.copyWith(
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
          _buildGraphic(),
          _buildQuestion(),
          _buildSelection(),
        ],
      ),
    );
  }

  Padding _buildQuestion() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'In what capacity do you want to contribute to the Flutter community?',
        style: Theme.of(context).textTheme.title,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSelection() {
    return Expanded(
      child: ListView(
        children: <Widget>[
          CheckboxListTile(
            title: Text('Volunteer'),
            value: _isVolunteer,
            onChanged: (bool? value) {
              setState(() => _isError = false);
              setState(() => _isVolunteer = value);
            },
          ),
          CheckboxListTile(
            title: Text('Administration & Logistics'),
            value: _isLogisticsAdministrator,
            onChanged: (bool? value) {
              setState(() => _isError = false);
              setState(() => _isLogisticsAdministrator = value);
            },
          ),
          CheckboxListTile(
            title: Text('Speaker'),
            value: _isSpeaker,
            onChanged: (bool? value) {
              setState(() => _isError = false);
              setState(() => _isSpeaker = value);
            },
          ),
          CheckboxListTile(
            title: Text('Social media marketing'),
            value: _isSocialMediaMarketingPerson,
            onChanged: (bool? value) {
              setState(() => _isError = false);
              setState(() => _isSocialMediaMarketingPerson = value);
            },
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
                onPressed: _submitDetails,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isError
                ? Text(
                    'Please select at least one option. You can also SKIP this step from the top right corner of this screen',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  void _submitDetails() async {
    if (!_validate()) return;
    try {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.update(userCache.user!.reference!, {
          'isContributor': true,
          'contribution': {
            'volunteer': _isVolunteer,
            'speaker': _isSpeaker,
            'administrationAndLogistics': _isLogisticsAdministrator,
            'socialMediMarketing': _isSocialMediaMarketingPerson,
          }
        });
      });
      await userCache.getUser(userCache.user!.id, useCached: false);
      Navigator.of(context).pop();
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
            },
          )
        ],
      ).show();
    }
  }

  Row _buildGraphic() {
    return Row(
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
    );
  }

  bool _validate() {
    if (!_isSocialMediaMarketingPerson! &&
        !_isSpeaker! &&
        !_isLogisticsAdministrator! &&
        !_isVolunteer!) {
      setState(() => _isError = true);
      return false;
    }

    return true;
  }
}
