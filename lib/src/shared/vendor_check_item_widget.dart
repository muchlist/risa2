import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/json_models/response/vendor_check_list_resp.dart';
import '../utils/utils.dart';

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
                ? Text("Pengecekan CCTV Virtual\n${data.createdBy.firstname}")
                : Text("Pengecekan CCTV Fisik\n${data.createdBy.firstname}"),
            subtitle: Text(dateDescription),
          ),
        ));
  }
}
