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
    Color? cardColor = Colors.teal[100];
    Color textIconColor = Colors.black87;
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
        child: Container(
          padding: const EdgeInsets.all(4.0),
          width: 120,
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                data.name.toLowerCase().capitalizeFirstofEach,
                style: TextStyle(fontSize: 14, color: textIconColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (data.isOffline)
                    Icon(
                      CupertinoIcons.multiply_circle,
                      size: 18,
                      color: textIconColor,
                    ),
                  if (data.isBlur)
                    Icon(
                      CupertinoIcons.circle_lefthalf_fill,
                      size: 18,
                      color: textIconColor,
                    ),
                  if (data.isChecked)
                    Icon(
                      CupertinoIcons.check_mark_circled,
                      size: 18,
                      color: textIconColor,
                    )
                ],
              )
            ],
          ),
        ));
  }
}
