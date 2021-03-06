import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/json_models/response/main_maintenance_list_resp.dart';
import '../utils/utils.dart';

class CctvMaintListTile extends StatelessWidget {
  const CctvMaintListTile({Key? key, required this.data}) : super(key: key);
  final MainMaintMinResponse data;

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
            // title: Text(data.name),
            title: (data.quarterlyMode)
                ? Text("Pengecekan Triwulan\n${data.name}")
                : Text("Pengecekan Bulanan\n${data.name}"),
            subtitle: Text(dateDescription),
          ),
        ));
  }
}
