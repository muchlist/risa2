import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/json_models/response/check_list_resp.dart';
import '../utils/date_unix.dart';

class CheckListTile extends StatelessWidget {
  const CheckListTile({Key? key, required this.data}) : super(key: key);
  final CheckMinResponse data;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: (data.isFinish)
              ? const Icon(CupertinoIcons.check_mark_circled)
              : const Icon(CupertinoIcons.timer_fill),
          title: Text(data.createdBy),
          subtitle: Text(data.updatedAt.getDateString()),
          trailing: Text("Shift ${data.shift}"),
        ));
  }
}
