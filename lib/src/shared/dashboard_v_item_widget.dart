import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/pallatte.dart';
import '../models/dashboard.dart';
import 'ui_helpers.dart';

class DashboardVIcon extends StatelessWidget {
  const DashboardVIcon(this.dashboardItem);
  final Dashboard dashboardItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          splashColor: Pallete.secondaryBackground,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: dashboardItem.color,
                borderRadius: BorderRadius.circular(5),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: Pallete.secondaryBackground,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                      spreadRadius: 2)
                ],
              ),
              child: Icon(
                dashboardItem.icon,
                color: Colors.white,
              ),
            ),
          ),
        ),
        verticalSpaceTiny,
        Flexible(
          child: Text(
            dashboardItem.title,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        )
      ],
    );
  }
}
