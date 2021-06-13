import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/pallatte.dart';
import '../../models/dashboard.dart';
import '../../providers/others.dart';
import '../../router/routes.dart';
import '../../shared/dashboard_icon_widget.dart';
import '../../shared/ui_helpers.dart';

class DashboardGrid extends StatefulWidget {
  @override
  _DashboardGridState createState() => _DashboardGridState();
}

class _DashboardGridState extends State<DashboardGrid> {
  var _primaryList = true;

  final List<Dashboard> dashboardItems = [
    Dashboard("Dashboard", CupertinoIcons.chart_bar_circle),
    Dashboard("Improvement", CupertinoIcons.rocket,
        route: RouteGenerator.improve),
    Dashboard("Stock", CupertinoIcons.rectangle_on_rectangle_angled,
        route: RouteGenerator.stock),
    Dashboard("Checklist", CupertinoIcons.chevron_down_square,
        route: RouteGenerator.check),
    Dashboard("Cctv", CupertinoIcons.camera, route: RouteGenerator.cctv),
    Dashboard("Komputer", CupertinoIcons.device_desktop,
        route: RouteGenerator.computer),
    Dashboard("Application", CupertinoIcons.square_stack_3d_up,
        route: RouteGenerator.other),
    Dashboard("Switch", CupertinoIcons.arrow_2_squarepath,
        color: Colors.brown.shade300),
  ];

  final List<Dashboard> dashboardItems2 = [
    Dashboard("UPS", CupertinoIcons.battery_25, route: RouteGenerator.other),
    Dashboard("Printer", CupertinoIcons.printer, route: RouteGenerator.other),
    Dashboard("Handheld", CupertinoIcons.device_laptop,
        route: RouteGenerator.other),
    Dashboard("Altai", CupertinoIcons.wifi, route: RouteGenerator.other),
    Dashboard("Server", CupertinoIcons.keyboard_chevron_compact_down,
        route: RouteGenerator.other),
    Dashboard("Gate", CupertinoIcons.building_2_fill,
        route: RouteGenerator.other),
    Dashboard("Other", CupertinoIcons.question_circle,
        color: Pallete.green.withOpacity(0.4), route: RouteGenerator.other),
    Dashboard("Switch", CupertinoIcons.arrow_2_squarepath,
        color: Colors.brown.shade300),
  ];

  @override
  Widget build(BuildContext context) {
    var selectedDashboard = <Dashboard>[];
    if (_primaryList) {
      selectedDashboard = dashboardItems;
    } else {
      selectedDashboard = dashboardItems2;
    }

    var width = screenWidth(context);
    var height = screenHeight(context);

    return NotificationListener(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        overScroll.disallowGlow();
        return false;
      },
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: selectedDashboard.length,
        shrinkWrap: true,
        itemBuilder: (ctx, i) => GestureDetector(
            onTap: () {
              if (selectedDashboard[i].title == "Switch") {
                setState(() {
                  _primaryList = !_primaryList;
                });
                return;
              }

              final route = selectedDashboard[i].route;
              if (route.isNotEmpty) {
                // jika route other harus mengisi sub kategori
                if (route == RouteGenerator.other) {
                  context
                      .read<OtherProvider>()
                      .setSubCategory(selectedDashboard[i].title.toUpperCase());
                }
                Navigator.of(context).pushNamed(route);
              } else {
                // menu not available
              }
            },
            child: DashboardIcon(selectedDashboard[i])),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: width ~/ 80,
            childAspectRatio: (width < height) ? 1 / 1.1 : 1 / 1.5,
            crossAxisSpacing: (width < height) ? 4 : 16,
            mainAxisSpacing: (width < height) ? 4 : 16),
      ),
    );
  }
}
