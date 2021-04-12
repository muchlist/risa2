import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/api/json_models/response/check_list_resp.dart';
import 'package:risa2/src/utils/date_unix.dart';

class CheckListTile extends StatelessWidget {
  final CheckMinResponse data;

  const CheckListTile({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: (data.isFinish)
          ? Icon(CupertinoIcons.check_mark_circled)
          : Icon(CupertinoIcons.timer_fill),
      title: Text(data.createdBy),
      subtitle: Text(DateTransform().unixToDateString(data.updatedAt)),
      trailing: Text("Shift ${data.shift}"),
    ));
  }
}
