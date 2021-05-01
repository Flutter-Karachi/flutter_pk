class EventDateTimeCache {
  DateTime? _eventDateTime;

  DateTime? get eventDateTime => _eventDateTime;

  void setDateTime(DateTime eventDateTime) {
    _eventDateTime = eventDateTime;
  }

  void clear() {
    _eventDateTime = null;
  }
}