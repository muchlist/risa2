import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/json_models/response/altai_virtual_list_resp.dart';
import '../utils/utils.dart';

class AltaiVirtualListTile extends StatelessWidget {
  const AltaiVirtualListTile({Key? key, required this.data}) : super(key: key);
  final AltaiVirtualMinResponse data;

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
            title: Text(data.createdBy),
            subtitle: Text(dateDescription),
          ),
        ));
  }
}
