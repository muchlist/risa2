import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'cached_image_square.dart';
import 'ui_helpers.dart';

class ConfigListData {
  ConfigListData({
    required this.title,
    required this.note,
    required this.diff,
    required this.imageUrl,
    required this.updatedAt,
    required this.updatedBy,
  });
  final String title;
  final String note;
  final String diff;
  final String imageUrl;
  final int updatedAt;
  final String updatedBy;
}

class ConfigListTile extends StatelessWidget {
  const ConfigListTile({Key? key, required this.data}) : super(key: key);
  final ConfigListData data;

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
        leading: (data.imageUrl.isNotEmpty)
            ? CachedImageSquare(
                urlPath: data.imageUrl,
                width: 50,
                height: 50,
              )
            : CircleAvatar(
                backgroundColor: Colors.blueGrey.shade300,
                foregroundColor: Colors.white,
                radius: 25,
                child: const Icon(Icons.close)),
        title: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            data.title,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (data.diff.isEmpty)
              Text("📝 ${data.note}")
            else
              Text("📝 ${data.note} \n🆕 ${data.diff}"),
            verticalSpaceSmall,
            Row(
              children: <Widget>[
                Text(
                  data.updatedAt.getDateString(),
                  maxLines: 1,
                ),
                const Spacer(),
                Text(
                  data.updatedBy.toLowerCase().split(" ")[0],
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
