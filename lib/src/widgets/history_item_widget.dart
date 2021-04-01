import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/api/json_models/response/history_list_resp.dart';
import 'package:risa2/src/utils/date_unix.dart';
import 'package:risa2/src/utils/enums.dart';

class HistoryListTile extends StatelessWidget {
  final HistoryMinResponse history;

  const HistoryListTile({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              width: 0.5),
          borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      child: ListTile(
        leading: Icon(CupertinoIcons.camera_circle),
        title: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            history.parentName,
            style: Theme.of(context).textTheme.bodyText1!,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (history.problemResolve.isEmpty)
                ? Text("📝 ${history.problem}")
                : Text("📝 ${history.problem} \n💡 ${history.problemResolve}"),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: (history.completeStatus == 4 ||
                              history.completeStatus == 0)
                          ? Colors.green.withOpacity(0.5)
                          : Color.fromRGBO(255, 186, 130, 0.15),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      enumStatus.values[history.completeStatus].toShortString(),
                      style: (history.completeStatus == 4 ||
                              history.completeStatus == 0)
                          ? TextStyle(color: Colors.white)
                          : TextStyle(color: Color.fromRGBO(255, 186, 130, 1)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(DateTransform().unixToDateString(history.dateStart)),
                SizedBox(
                  width: 10,
                ),
                Text(history.updatedBy.toLowerCase())
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
