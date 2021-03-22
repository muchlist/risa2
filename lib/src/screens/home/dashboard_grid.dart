import 'package:flutter/material.dart';
import 'package:risa2/src/screens/home/dashboard_icon.dart';

class DashboardGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        overScroll.disallowGlow();
        return false;
      },
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 4,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        children: <Widget>[
          DashboardIcon(),
          DashboardIcon(),
          DashboardIcon(),
          DashboardIcon(),
          DashboardIcon(),
          DashboardIcon(),
          DashboardIcon(),
        ],
      ),
    );
  }
}
