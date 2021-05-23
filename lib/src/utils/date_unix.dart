import 'package:intl/intl.dart';

extension UnixTimeStamp on int {
  String getDateString() {
    var date = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    return DateFormat("d MMM HH:mm").format(date.toLocal());
  }

  String getHourString() {
    var date = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    return DateFormat("HH:mm").format(date.toLocal());
  }

  String getMonthYear() {
    var date = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    return DateFormat("MMM y").format(date.toLocal());
  }
}

extension DateMYString on DateTime {
  String getMonthYearDisplay() {
    return DateFormat("MMM y").format(toLocal());
  }
}
