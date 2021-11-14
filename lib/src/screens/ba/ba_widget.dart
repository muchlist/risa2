import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/api/json_models/response/ba_list_resp.dart';
import 'package:risa2/src/api/json_models/response/ba_resp.dart';
import 'package:risa2/src/config/constant.dart';
import 'package:risa2/src/shared/cached_image_square.dart';
import '../../utils/utils.dart';

class BaListTile extends StatelessWidget {
  const BaListTile({Key? key, required this.data}) : super(key: key);
  final BaMinResponse data;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(data.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.deepOrange.shade50,
                    ),
                    child: Text(" ${data.number} ")),
                Text(data.date.getDateWithYearString() + " ${data.createdBy}"),
              ],
            ),
          ),
        ));
  }
}

const double _signDimension = 100.0;

class BaSignWidget extends StatelessWidget {
  const BaSignWidget({Key? key, required this.data}) : super(key: key);
  final Participant data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(3)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(data.position),
          if (data.sign.isNotEmpty)
            CachedImageSquare(
              urlPath: "${Constant.baseUrl}${data.sign}",
              width: _signDimension,
              height: _signDimension,
            )
          else
            const SizedBox(
              width: _signDimension,
              height: _signDimension,
              child: Icon(
                CupertinoIcons.qrcode,
                size: 40,
                color: Colors.grey,
              ),
            ),
          Text(data.name),
        ],
      ),
    );
  }
}
