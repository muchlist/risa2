import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/models/dashboard.dart';
import 'package:risa2/src/widgets/dashboard_icon.dart';

class DashboardGrid extends StatelessWidget {
  final List<Dashboard> dashboardItems = [
    Dashboard("Dashboard", CupertinoIcons.chart_bar_circle),
    Dashboard("Improvement", CupertinoIcons.rocket),
    Dashboard("Stock", CupertinoIcons.rectangle_on_rectangle_angled),
    Dashboard("Checklist", CupertinoIcons.chevron_down_square,
        color: Color(0xffBBBAFF)),
    Dashboard("Export", CupertinoIcons.upload_circle, color: Color(0xffBBBAFF)),
    Dashboard("Hardware", CupertinoIcons.device_desktop,
        color: Color(0xffBBBAFF)),
    Dashboard("Software", CupertinoIcons.square_stack_3d_up,
        color: Color(0xffBBBAFF)),
    Dashboard("Incident", CupertinoIcons.smallcircle_circle,
        color: Color(0xffBBBAFF)),
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return NotificationListener(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        overScroll.disallowGlow();
        return false;
      },
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: dashboardItems.length,
        shrinkWrap: true,
        itemBuilder: (ctx, i) => DashboardIcon(dashboardItems[i]),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: width ~/ 80,
            childAspectRatio: (width < height) ? 1 / 1.1 : 1 / 1.5,
            crossAxisSpacing: (width < height) ? 4 : 16,
            mainAxisSpacing: (width < height) ? 4 : 16),
      ),
    );
  }
}
