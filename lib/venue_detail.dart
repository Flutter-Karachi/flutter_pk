import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/venue_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_indicators/progress_indicators.dart';

class VenueDetailPage extends StatefulWidget {
  @override
  VenueDetailPageState createState() {
    return new VenueDetailPageState();
  }
}

class VenueDetailPageState extends State<VenueDetailPage> {
  GoogleMapController mapController;
  bool _isLoading = false;
  Venue _venue = new Venue();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addMarker(_venue);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[_buildBody()],
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: _isLoading
          ? Center(
              child: HeartbeatProgressIndicator(
                  child: SizedBox(
                height: 40.0,
                width: 40.0,
                child: Image(
                  image: AssetImage('assets/map.png'),
                  color: Colors.blue,
                ),
              )),
            )
          : Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  compassEnabled: true,
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _venue.location.latitude,
                        _venue.location.longitude,
                      ),
                      zoom: 15.0),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Card(
                            elevation: 4.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 64.0, right: 64.0, top: 16.0),
                                  child: Image(
                                    image: NetworkImage(
                                      _venue.imageUrl,
                                      scale: 0.5,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _venue.address,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  _getData() {
    setState(() {
      _isLoading = true;
    });
    EventDetails _eventDetails = new EventDetails();
    var eventDetails = Firestore.instance
        .collection(FireStoreKeys.dateCollection)
        .snapshots()
        .first;
    eventDetails.then((onValue) {
      _eventDetails = EventDetails(
          reference: onValue.documents.first.reference,
          venue: Venue(
              address: onValue.documents.first['venue']['address'],
              title: onValue.documents.first['venue']['title'],
              city: onValue.documents.first['venue']['city'],
              imageUrl: onValue.documents.first['venue']['imageUrl'],
              location: Location(
                latitude: onValue.documents.first['venue']['location']
                    ['latitude'],
                longitude: onValue.documents.first['venue']['location']
                    ['longitude'],
              )));
      setState(() {
        _venue = _eventDetails.venue;
        _isLoading = false;
      });
    });
  }

  void _addMarker(Venue venue) {
    mapController.addMarker(
      MarkerOptions(
        position: LatLng(venue.location.latitude, venue.location.longitude),
        infoWindowText: InfoWindowText(venue.title, venue.city),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ),
      ),
    );
  }
}
