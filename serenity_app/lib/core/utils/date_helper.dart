import 'package:intl/intl.dart';

class DateHelper {
  // DateTime object to string
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    final DateFormat dateFormat = DateFormat(format);
    return dateFormat.format(date);
  }

  // Parse a string to a DateTime object based on a given format
  static DateTime parseDate(String dateString, {String format = 'yyyy-MM-dd'}) {
    final DateFormat dateFormat = DateFormat(format);
    return dateFormat.parse(dateString);
  }

  // Get the current date formatted as a string
  static String getCurrentDate({String format = 'yyyy-MM-dd'}) {
    final DateTime now = DateTime.now();
    return formatDate(now, format: format);
  }

  // Get the current date with time formatted as a string
  static String getCurrentDateTime({String format = 'yyyy-MM-dd HH:mm:ss'}) {
    final DateTime now = DateTime.now();
    return formatDate(now, format: format);
  }

  // Get the current time formatted (HH:mm)
  static String getCurrentTime({String format = 'HH:mm'}) {
    final DateTime now = DateTime.now();
    return formatDate(now, format: format);
  }

  // Get the current date formatted with only the date (without time)
  static String getCurrentDateOnly() {
    final DateTime now = DateTime.now();
    return formatDate(now, format: 'yyyy-MM-dd');
  }

  // Get the current time with hour and minute (24-hour format)
  static String getCurrentTimeOnly() {
    final DateTime now = DateTime.now();
    return formatDate(now, format: 'HH:mm');
  }

  // Convert DateTime to a human-readable string without the timezone
  static String formatDateWithoutTimeZone(DateTime date) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return dateFormat.format(date);
  }

  // Convert DateTime to a string with just the date (no time)
  static String formatDateOnly(DateTime date) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(date);
  }

  // Convert DateTime to a string with just the time (no date)
  static String formatTimeOnly(DateTime date) {
    final DateFormat dateFormat = DateFormat('HH:mm');
    return dateFormat.format(date);
  }

  // Method to format the transaction date to just the date (yyyy-MM-dd)
  static String formatTransactionDateToDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return formatDateOnly(parsedDate);
    } catch (e) {
      return date;
    }
  }

  // Method to format the transaction date to just the time (HH:mm)
  static String formatTransactionDateToTime(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date); // Parse the string to DateTime
      return formatTimeOnly(parsedDate); // Return only the time part
    } catch (e) {
      return date; // If parsing fails, return the original string
    }
  }

  static DateTime resetTimeToMidnight(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }


  static String resetTimeFromString(String dateString, {String format = 'yyyy-MM-dd'}) {
    try {
      DateTime parsedDate = DateTime.parse(dateString);
      DateTime resetDate = resetTimeToMidnight(parsedDate);
      return formatDateOnly(resetDate);
    } catch (e) {
      return dateString;
    }
  }
}
