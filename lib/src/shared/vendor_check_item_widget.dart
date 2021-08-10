import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/json_models/response/vendor_check_list_resp.dart';
import '../utils/date_unix.dart';

class VendorCheckListTile extends StatelessWidget {
  const VendorCheckListTile({Key? key, required this.data}) : super(key: key);
  final VendorCheckMinResponse data;

  @override
  Widget build(BuildContext context) {
    String dateDescription = data.timeStarted.getDateString();
    if (data.timeEnded != 0) {
      dateDescription += "   ~   ${data.timeEnded.getDateString()}";
    }

    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: ListTile(
            leading: (data.isFinish)
                ? const Icon(CupertinoIcons.check_mark_circled)
                : const Icon(CupertinoIcons.timer_fill),
            title: (data.isVirtualCheck)
                ? const Text("Pengecekan Virtual")
                : const Text("Pengecekan Fisik"),
            subtitle: Text(dateDescription),
          ),
        ));
  }
}
