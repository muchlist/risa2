import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/content.dart';
import '../../models/dashboard.dart';
import '../../providers/others.dart';
import '../../router/routes.dart';
import '../../shared/dashboard_icon_widget.dart';
import '../../shared/disable_glow.dart';

class DashboardGrid extends StatefulWidget {
  @override
  _DashboardGridState createState() => _DashboardGridState();
}

class _DashboardGridState extends State<DashboardGrid> {
  final List<Dashboard> dashboardItems = Content.homeMenu;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
      width: double.infinity,
      height: 190,
      child: DisableOverScrollGlow(
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dashboardItems.length,
          shrinkWrap: true,
          itemBuilder: (ctx, i) => GestureDetector(
              onTap: () {
                final route = dashboardItems[i].route;
                if (route.isNotEmpty) {
                  // jika route other harus mengisi sub kategori
                  if (route == RouteGenerator.other) {
                    context
                        .read<OtherProvider>()
                        .setSubCategory(dashboardItems[i].title.toUpperCase());
                  }
                  Navigator.of(context).pushNamed(route);
                } else {
                  // menu not available
                }
              },
              child: DashboardIcon(dashboardItems[i])),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 1,
            crossAxisSpacing: 15,
            mainAxisSpacing: 5,
          ),
        ),
      ),
    ));
  }
}
