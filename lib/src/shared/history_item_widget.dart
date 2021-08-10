import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/json_models/response/history_list_resp.dart';
import '../config/constant.dart';
import '../config/histo_icon.dart';
import '../utils/utils.dart';
import 'cached_image_square.dart';
import 'ui_helpers.dart';

class HistoryListTile extends StatelessWidget {
  const HistoryListTile({Key? key, required this.history}) : super(key: key);
  final HistoryMinResponse history;

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
        leading: (history.image.isNotEmpty)
            ? CachedImageSquare(
                urlPath: "${Constant.baseUrl}${history.image.thumbnailMod()}",
                width: 50,
                height: 50,
              )
            : CircleAvatar(
                backgroundColor: Colors.blueGrey.shade300,
                foregroundColor: Colors.white,
                radius: 25,
                child: Icon(getIcon(history.category)),
              ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            history.parentName,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (history.problemResolve.isEmpty)
              Text("📝 ${history.problem}")
            else
              Text("📝 ${history.problem} \n💡 ${history.problemResolve}"),
            verticalSpaceSmall,
            Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: (history.completeStatus == 4 ||
                              history.completeStatus == 0)
                          ? Colors.green.withOpacity(0.5)
                          : const Color.fromRGBO(255, 186, 130, 0.15),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      enumStatus.values[history.completeStatus].toShortString(),
                      maxLines: 1,
                      style: (history.completeStatus == 4 ||
                              history.completeStatus == 0)
                          ? const TextStyle(color: Colors.white)
                          : TextStyle(color: Colors.deepOrange[300]),
                    ),
                  ),
                ),
                horizontalSpaceSmall,
                Text(
                  history.updatedAt.getDateString(),
                  maxLines: 1,
                ),
                const Spacer(),
                Text(
                  history.updatedBy.toLowerCase().split(" ")[0],
                  maxLines: 1,
                )
              ],
            ),
            verticalSpaceSmall,
          ],
        ),
      ),
    );
  }
}
