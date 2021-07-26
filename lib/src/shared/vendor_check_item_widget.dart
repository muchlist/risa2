import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/json_models/response/vendor_check_list_resp.dart';
import '../utils/date_unix.dart';

class VendorCheckListTile extends StatelessWidget {
  final VendorCheckMinResponse data;

  const VendorCheckListTile({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: (data.isFinish)
              ? const Icon(CupertinoIcons.check_mark_circled)
              : const Icon(CupertinoIcons.timer_fill),
          title: (data.isVirtualCheck)
              ? const Text("Pengecekan virtual")
              : const Text("Pengecekan Fisik"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Dimulai : ${data.timeStarted.getDateString()}"),
              if (data.timeEnded != 0)
                Text("Selesai : ${data.timeEnded.getDateString()}"),
            ],
          ),
        ));
  }
}
