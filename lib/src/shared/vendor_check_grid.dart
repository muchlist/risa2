import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/api/json_models/response/vendor_check_resp.dart';
import '../utils/utils.dart';

class VendorGridItemTile extends StatelessWidget {
  const VendorGridItemTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  final VendorCheckItem data;

  @override
  Widget build(BuildContext context) {
    var cardColor = Colors.teal[100];
    var textIconColor = Colors.black87;
    if (data.isOffline) {
      cardColor = Colors.red[300];
      textIconColor = Colors.white;
    } else if (data.isBlur) {
      cardColor = Colors.deepOrange[300];
      textIconColor = Colors.white;
    } else if (data.isChecked) {
      cardColor = Colors.teal[400];
      textIconColor = Colors.white;
    }

    return Card(
        color: cardColor,
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Container(
            padding: EdgeInsets.all(4.0),
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.name.toLowerCase().capitalizeFirstofEach,
                  style: TextStyle(fontSize: 14, color: textIconColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (data.isOffline)
                      Icon(
                        CupertinoIcons.power,
                        size: 18,
                        color: textIconColor,
                      ),
                    if (data.isBlur)
                      Icon(
                        CupertinoIcons.snow,
                        size: 18,
                        color: textIconColor,
                      ),
                    if (data.isChecked)
                      Icon(
                        CupertinoIcons.check_mark,
                        size: 18,
                        color: textIconColor,
                      )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
