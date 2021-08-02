import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/json_models/response/history_list_resp.dart';
import '../config/constant.dart';
import '../utils/utils.dart';
import 'cached_image_square.dart';
import 'ui_helpers.dart';

class HistoryVCListTile extends StatelessWidget {
  final HistoryMinResponse history;

  const HistoryVCListTile({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              width: 0.5),
          borderRadius: BorderRadius.circular(5)),
      elevation: 0,
      child: ListTile(
        leading: (history.image.isNotEmpty)
            ? CachedImageSquare(
                urlPath: "${Constant.baseUrl}${history.image.thumbnailMod()}",
                height: 40,
                width: 40,
              )
            : Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.blueGrey.shade300,
                    borderRadius: BorderRadius.circular(5)),
              ),
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
            verticalSpaceSmall,
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
                      maxLines: 1,
                      style: (history.completeStatus == 4 ||
                              history.completeStatus == 0)
                          ? TextStyle(color: Colors.white)
                          : TextStyle(color: Colors.deepOrange[300]),
                    ),
                  ),
                ),
                horizontalSpaceSmall,
                Text(
                  history.updatedAt.getDateString(),
                  maxLines: 1,
                ),
                Spacer(),
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
