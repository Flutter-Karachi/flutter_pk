import 'package:intl/intl.dart';

abstract class DateFormats {
  static String shortUiDateTimeFormat = 'MMM dd, yyyy, h:mm a';
  static String shortUiDateFormat = 'MMM dd, yyyy';
  static String shortUiTimeFormat = 'h:mm a';
}

String formatDate(DateTime date, String format) {
  var formatter = new DateFormat(format);
  return formatter.format(date);
}