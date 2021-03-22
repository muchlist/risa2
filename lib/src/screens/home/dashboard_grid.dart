import 'package:flutter/material.dart';
import 'package:risa2/src/models/dashboard_category.dart';
import 'package:risa2/src/screens/home/dashboard_icon.dart';

class DashboardGrid extends StatelessWidget {
  final List<DashboardItem> dashboardItems = [
    DashboardItem("Dashboard", ""),
    DashboardItem("Improvement", ""),
    DashboardItem("Stock", ""),
    DashboardItem("Checklist", ""),
    DashboardItem("Export", ""),
    DashboardItem("Hardware", ""),
    DashboardItem("Software", ""),
    DashboardItem("Incident", ""),
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return NotificationListener(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        overScroll.disallowGlow();
        return false;
      },
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: dashboardItems.length,
        shrinkWrap: true,
        itemBuilder: (ctx, i) => DashboardIcon(
            title: dashboardItems[i].title, image: dashboardItems[i].icon),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: width ~/ 80,
            childAspectRatio: (width < height) ? 1 / 1 : 1 / 1.5,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4),
      ),
    );
  }
}
