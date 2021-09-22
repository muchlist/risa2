import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/json_models/response/config_check_resp.dart';
import '../utils/utils.dart';

class ConfigCheckListTile extends StatelessWidget {
  const ConfigCheckListTile({Key? key, required this.data}) : super(key: key);
  final ConfigCheckDetailResponseData data;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: ListTile(
            leading: (data.isFinish)
                ? const Icon(CupertinoIcons.check_mark_circled)
                : const Icon(CupertinoIcons.timer_fill),
            title: Text("Backup Config ${data.createdAt.getMonthYear()}"),
            subtitle: Text(data.createdAt.getDateString()),
          ),
        ));
  }
}
