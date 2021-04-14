import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../config/pallatte.dart';
import '../../models/dashboard.dart';
import '../../router/routes.dart';
import '../../shared/dashboard_icon_widget.dart';
import '../../shared/ui_helpers.dart';

class DashboardGrid extends StatelessWidget {
  // List Icon and title
  final List<Dashboard> dashboardItems = [
    Dashboard("Dashboard", CupertinoIcons.chart_bar_circle),
    Dashboard("Improvement", CupertinoIcons.rocket),
    Dashboard("Stock", CupertinoIcons.rectangle_on_rectangle_angled),
    Dashboard("Checklist", CupertinoIcons.chevron_down_square,
        color: Pallete.green.withOpacity(0.4), route: RouteGenerator.check),
    Dashboard("Export", CupertinoIcons.upload_circle,
        color: Pallete.green.withOpacity(0.4)),
    Dashboard("Hardware", CupertinoIcons.device_desktop,
        color: Pallete.green.withOpacity(0.4)),
    Dashboard("Software", CupertinoIcons.square_stack_3d_up,
        color: Pallete.green.withOpacity(0.4)),
    Dashboard("Incident", CupertinoIcons.smallcircle_circle,
        color: Pallete.green.withOpacity(0.4)),
  ];

  @override
  Widget build(BuildContext context) {
    var width = screenWidth(context);
    var height = screenHeight(context);

    return NotificationListener(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        overScroll.disallowGlow();
        return false;
      },
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: dashboardItems.length,
        shrinkWrap: true,
        itemBuilder: (ctx, i) => GestureDetector(
            onTap: () {
              final route = dashboardItems[i].route;
              if (route.isNotEmpty) {
                Navigator.of(context).pushNamed(RouteGenerator.check);
              }
            },
            child: DashboardIcon(dashboardItems[i])),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: width ~/ 80,
            childAspectRatio: (width < height) ? 1 / 1.1 : 1 / 1.5,
            crossAxisSpacing: (width < height) ? 4 : 16,
            mainAxisSpacing: (width < height) ? 4 : 16),
      ),
    );
  }
}
