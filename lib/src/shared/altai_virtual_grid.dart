import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/json_models/response/altai_virtual_resp.dart';

class AltaiVGridItemTile extends StatelessWidget {
  const AltaiVGridItemTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  final AltaiCheckItem data;

  @override
  Widget build(BuildContext context) {
    Color? cardColor = Colors.teal[100];
    Color textIconColor = Colors.black87;
    if (data.isOffline) {
      cardColor = Colors.red[300];
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
                data.name,
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
