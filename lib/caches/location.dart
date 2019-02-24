
class LocationCache {
  String _longitude;
  String _latitude;

  String get longitude => _longitude;
  String get latitude => _latitude;

  void setLocation(String longitude, String latitude) {
    _longitude = longitude;
    _latitude = latitude;
  }

  void clear() {
    _longitude = null;
    _latitude = null;
  }
}
