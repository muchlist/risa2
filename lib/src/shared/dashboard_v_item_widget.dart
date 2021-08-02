import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/pallatte.dart';
import '../models/dashboard.dart';
import 'ui_helpers.dart';

class DashboardVIcon extends StatelessWidget {
  final Dashboard dashboardItem;

  const DashboardVIcon(this.dashboardItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          InkWell(
            splashColor: Pallete.secondaryBackground,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Container(
                child: Icon(
                  dashboardItem.icon,
                  color: Colors.white,
                ),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: dashboardItem.color,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        color: Pallete.secondaryBackground,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                        spreadRadius: 2)
                  ],
                ),
              ),
            ),
          ),
          verticalSpaceTiny,
          Flexible(
            child: Text(
              dashboardItem.title,
              style: TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}
