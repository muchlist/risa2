import 'package:intl/intl.dart';

extension UnixTimeStamp on int {
  String getDateString() {
    var date = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    return DateFormat("d MMM HH:mm").format(date.toLocal());
  }
}
