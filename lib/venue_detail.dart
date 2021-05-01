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
  GoogleMapController? mapController;
  bool _isLoading = false;
  Venue? _venue = new Venue();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

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
                  color: Theme.of(context).primaryColor,
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
                  markers: Set<Marker>.of(markers.values),
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _venue!.location!.latitude!,
                        _venue!.location!.longitude!,
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
                                      _venue!.imageUrl!,
                                      scale: 0.5,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _venue!.address!,
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
    var eventDetails = FirebaseFirestore.instance
        .collection(FireStoreKeys.dateCollection)
        .snapshots()
        .first;
    eventDetails.then((onValue) {
      locationCache.setLocation(
        onValue.docs.first.data()['venue']['location']['longitude'].toString(),
        onValue.docs.first.data()['venue']['location']['latitude'].toString(),
      );
      _eventDetails = EventDetails(
          reference: onValue.docs.first.reference,
          venue: Venue(
              address: onValue.docs.first.data()['venue']['address'],
              title: onValue.docs.first.data()['venue']['title'],
              city: onValue.docs.first.data()['venue']['city'],
              imageUrl: onValue.docs.first.data()['venue']['imageUrl'],
              location: Location(
                latitude: onValue.docs.first.data()['venue']['location']
                    ['latitude'],
                longitude: onValue.docs.first.data()['venue']['location']
                    ['longitude'],
              )));
      setState(() {
        _venue = _eventDetails.venue;
        _isLoading = false;
      });
    });
  }

  void _addMarker(Venue? venue) {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final MarkerId markerId = MarkerId(venue!.city!);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(venue.location!.latitude!, venue.location!.longitude!),
      infoWindow: InfoWindow(title: venue.title, snippet: venue.city),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueAzure,
      ),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }
}
