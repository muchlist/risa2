import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/json_models/response/stock_list_resp.dart';
import '../config/constant.dart';
import 'cached_image_circle.dart';

class StockListTile extends StatelessWidget {
  final StockMinResponse data;

  const StockListTile({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: (data.image.isNotEmpty)
          ? CachedImageCircle(urlPath: "${Constant.baseUrl}${data.image}")
          : null,
      title: Text(data.name),
      subtitle: Row(
        children: [
          Text(data.stockCategory.toLowerCase()),
          Spacer(),
          Text("Sisa : ${data.qty} ${data.unit}"),
        ],
      ),
      trailing: (data.qty <= data.threshold)
          ? Icon(
              CupertinoIcons.exclamationmark_circle,
              color: Colors.red,
            )
          : null,
    ));
  }
}
