import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/config/pallatte.dart';
import 'package:risa2/src/models/dashboard.dart';

class DashboardIcon extends StatelessWidget {
  final Dashboard dashboardItem;

  const DashboardIcon(this.dashboardItem);

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
                  borderRadius: BorderRadius.circular(25),
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
          const SizedBox(
            height: 2,
          ),
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
