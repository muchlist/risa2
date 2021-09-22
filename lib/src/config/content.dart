import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/dashboard.dart';
import '../router/routes.dart';
import 'pallatte.dart';

class Content {
  static final List<Dashboard> homeMenu = <Dashboard>[
    const Dashboard("Dashboard", CupertinoIcons.chart_bar_circle,
        route: RouteGenerator.dashboard),
    const Dashboard("Cctv", CupertinoIcons.camera, route: RouteGenerator.cctv),
    const Dashboard("Computer", CupertinoIcons.device_desktop,
        route: RouteGenerator.computer),
    const Dashboard("Stock", CupertinoIcons.rectangle_on_rectangle_angled,
        route: RouteGenerator.stock),
    const Dashboard("Improvement", CupertinoIcons.rocket,
        route: RouteGenerator.improve),
    const Dashboard("Checklist", CupertinoIcons.chevron_down_square,
        route: RouteGenerator.check),
    const Dashboard("Check Virtual", CupertinoIcons.checkmark_seal,
        route: RouteGenerator.vendorCheck),
    const Dashboard("Application", CupertinoIcons.square_stack_3d_up,
        route: RouteGenerator.other),
    const Dashboard("Altai", CupertinoIcons.wifi, route: RouteGenerator.other),
    const Dashboard("Handheld", CupertinoIcons.device_laptop,
        route: RouteGenerator.other),
    const Dashboard("UPS", CupertinoIcons.battery_25,
        route: RouteGenerator.other),
    const Dashboard("Printer", CupertinoIcons.printer,
        route: RouteGenerator.other),
    const Dashboard("Server", CupertinoIcons.keyboard_chevron_compact_down,
        route: RouteGenerator.other),
    const Dashboard("Gate", CupertinoIcons.building_2_fill,
        route: RouteGenerator.other),
    const Dashboard("Network", CupertinoIcons.link,
        route: RouteGenerator.other),
    Dashboard("Fisik CCTV", CupertinoIcons.doc_checkmark,
        route: RouteGenerator.cctvMaintenance,
        color: Colors.deepOrange.shade300),
    Dashboard("Fisik Altai", CupertinoIcons.checkmark_rectangle,
        route: RouteGenerator.altaiMaintenance,
        color: Colors.deepOrange.shade300),
    Dashboard("Cfg Server", CupertinoIcons.greaterthan_circle_fill,
        route: RouteGenerator.configCheck, color: Colors.deepOrange.shade300),
    Dashboard("Other", CupertinoIcons.question_circle,
        color: Pallete.green.withOpacity(0.4), route: RouteGenerator.other),
  ];
}
