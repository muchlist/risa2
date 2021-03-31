import 'package:intl/intl.dart';

class DateTransform {
  const DateTransform();

  String unixToDateString(int unixMiliSecond) {
    var date = DateTime.fromMillisecondsSinceEpoch(unixMiliSecond * 1000);
    return DateFormat("d MMM HH:mm").format(date.toLocal());
  }
}
