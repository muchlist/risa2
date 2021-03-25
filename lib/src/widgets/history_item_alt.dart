import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/models/history_preview.dart';

class HistoryListTile extends StatelessWidget {
  final HistoryPreview history;

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
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            history.title,
            style: TextStyle(fontSize: 18),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${history.incidentNote}\n #${history.resolveNote}"),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 186, 130, 0.15),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      history.completeStatus,
                      style: TextStyle(color: Color.fromRGBO(255, 186, 130, 1)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(history.date),
                SizedBox(
                  width: 10,
                ),
                Text(history.author)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
