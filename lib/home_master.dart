import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pk/caches/user.dart';
import 'package:flutter_pk/venue_detail.dart';
import 'package:flutter_pk/global.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_pk/registration/registration.dart';
import 'package:flutter_pk/widgets/full_screen_loader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_pk/schedule/schedule_page.dart';

class HomePageMaster extends StatefulWidget {
  @override
  HomePageMasterState createState() {
    return new HomePageMasterState();
  }
}

class HomePageMasterState extends State<HomePageMaster> {
  int _selectedIndex = 0;
  String floatingButtonLabel = 'Register';
  IconData floatingButtonIcon = Icons.group_work;
  String latitude = '24.863690';
  String longitude = '67.075474';
  bool _isLoading = false;
  User _user = new User();
  List<Widget> widgets = <Widget>[
    SchedulePage(),
    Center(
      child: Text('Hello two'),
    ),
    VenueDetailPage()
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      sized: false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _isLoading
            ? null
            : FloatingActionButton.extended(
                onPressed: _floatingButtonTapModerator,
//          Alert(
//                  context: context,
//                  type: AlertType.info,
//                  title: "Information!",
//                  desc:
//                      "You will be able to scan a QR on the event day!\nCheers!",
//                  buttons: [
//                    DialogButton(
//                      child: Text("Cool!",
//                          style: Theme.of(context).textTheme.title.copyWith(
//                                color: Colors.white,
//                              )),
//                      color: Colors.green,
//                      onPressed: () {
//                        Navigator.of(context).pop();
//                      },
//                    )
//                  ],
//                ).show()
                icon: Icon(floatingButtonIcon),
                label: Text(floatingButtonLabel),
              ),
        body: Stack(
          children: <Widget>[
            widgets.elementAt(_selectedIndex),
            _isLoading ? FullScreenLoader() : Container()
          ],
        ),
        bottomNavigationBar: _isLoading
            ? null
            : BottomNavigationBar(
                onTap: (value) {
                  floatingButtonLabel =
                      _user.isRegistered ? 'Scan QR' : 'Register';
                  floatingButtonIcon = _user.isRegistered
                      ? Icons.center_focus_weak
                      : Icons.group_work;
                  if (value == 2) {
                    floatingButtonLabel = 'Navigate';
                    floatingButtonIcon = Icons.my_location;
                  }
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
                      icon: Icon(Icons.location_on), title: Text('Venue')),
                ],
              ),
      ),
    );
  }

  void _floatingButtonTapModerator() {
    if (_selectedIndex == 2) {
      _navigateToGoogleMaps();
    } else if (_user.isRegistered) {
      _scanQr();
    } else {
      _navigateToRegistration(context);
    }
  }

  void _navigateToGoogleMaps() async {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    String googleUrl = '';
    if (isIOS) {
      googleUrl =
          'comgooglemapsurl://maps.google.com/maps?f=d&daddr=$latitude,$longitude&sspn=0.2,0.1';
      String appleMapsUrl = 'https://maps.apple.com/?sll=$latitude,$longitude';
      if (await canLaunch("comgooglemaps://")) {
        print('launching com googleUrl');
        await launch(googleUrl);
      } else if (await canLaunch(appleMapsUrl)) {
        print('launching apple url');
        await launch(appleMapsUrl);
      } else {
        await launch(
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
      }
    } else {
      googleUrl = 'google.navigation:q=$latitude,$longitude&mode=d';
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        await launch(
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
      }
    }
  }

  Future<String> _scanQr() async {
    try {
      String qrDataString = await BarcodeScanner.scan();
      print(qrDataString);
      if (qrDataString == GlobalConstants.qrKey) {
        setState(() {
          _isLoading = true;
        });
        DocumentReference attendanceReference = Firestore.instance
            .collection(FireStoreKeys.attendanceCollection)
            .document(FireStoreKeys.dateReferenceString);

        CollectionReference attendeeCollectionReference =
            attendanceReference.collection(FireStoreKeys.attendeesCollection);

        int attendanceCount;
        await Firestore.instance
            .collection(FireStoreKeys.attendanceCollection)
            .document(FireStoreKeys.dateReferenceString)
            .get()
            .then((onValue) {
          attendanceCount = onValue['attendanceCount'];
        });

        await attendanceReference
            .setData({'attendanceCount': attendanceCount + 1}, merge: true);

        await attendeeCollectionReference.document(userCache.user.id).setData(
          {'userName': userCache.user.name},
          merge: true,
        );
        Alert(
          context: context,
          type: AlertType.success,
          title: "Yayy!",
          desc: "You have been marked present! Enjoy the event!",
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
        ).show();
      } else {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "Oops!",
          desc: "Looks like you scanned an invalid QR",
          buttons: [
            DialogButton(
              child: Text("Dismiss",
                  style: Theme.of(context).textTheme.title.copyWith(
                        color: Colors.white,
                      )),
              color: Colors.blueGrey,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ).show();
      }
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
                style: Theme.of(context).textTheme.title.copyWith(
                      color: Colors.white,
                    )),
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ).show();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _navigateToRegistration(BuildContext context) async {
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
    _setUser();
  }

  Future _setUser() async {
    var user = await userCache.getCurrentUser(userCache.user.id);
    setState(() {
      _user = user;
      floatingButtonLabel = _user.isRegistered ? 'Scan QR' : 'Register';
      floatingButtonIcon =
          _user.isRegistered ? Icons.center_focus_weak : Icons.group_work;
    });
  }
}
