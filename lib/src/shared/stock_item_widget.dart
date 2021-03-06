import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/json_models/response/stock_list_resp.dart';
import '../config/constant.dart';
import '../utils/string_modifier.dart';
import 'cached_image_square.dart';

class StockListTile extends StatelessWidget {
  const StockListTile({Key? key, required this.data}) : super(key: key);
  final StockMinResponse data;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
            leading: (data.image.isNotEmpty)
                ? CachedImageSquare(
                    urlPath: "${Constant.baseUrl}${data.image.thumbnailMod()}",
                    width: 50,
                    height: 50,
                  )
                : null,
            title: Text(data.name),
            subtitle: Row(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green.shade100,
                    ),
                    child: Text(" ${data.stockCategory.toLowerCase()} ")),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text("${data.qty} ${data.unit}"),
                if (data.qty <= data.threshold)
                  const Icon(
                    CupertinoIcons.exclamationmark_circle,
                    color: Colors.red,
                  )
                else
                  const SizedBox.shrink(),
              ],
            )));
  }
}
