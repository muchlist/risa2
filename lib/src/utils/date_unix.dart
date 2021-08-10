import 'package:intl/intl.dart';

extension UnixTimeStamp on int {
  DateTime toDate() {
    return DateTime.fromMillisecondsSinceEpoch(this * 1000);
  }

  String getDateString() {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    return DateFormat("d MMM HH:mm").format(date.toLocal());
  }

  String getHourString() {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    return DateFormat("HH:mm").format(date.toLocal());
  }

  String getMonthYear() {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    return DateFormat("MMM y").format(date.toLocal());
  }

  String getCompleteDateString() {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    return DateFormat("d MMM y HH:mm").format(date.toLocal());
  }
}

extension DateMYString on DateTime {
  String getMonthYearDisplay() {
    return DateFormat("MMM y").format(toLocal());
  }

  int toInt() {
    return millisecondsSinceEpoch ~/ 1000;
  }
}
