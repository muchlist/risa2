import 'package:flutter/cupertino.dart';
import 'package:risa2/src/config/pallatte.dart';
import 'package:risa2/src/models/dashboard.dart';
import 'package:risa2/src/router/routes.dart';

class Content {
  static final homeMenu = [
    Dashboard("Dashboard", CupertinoIcons.chart_bar_circle,
        route: RouteGenerator.dashboard),
    Dashboard("Cctv", CupertinoIcons.camera, route: RouteGenerator.cctv),
    Dashboard("Computer", CupertinoIcons.device_desktop,
        route: RouteGenerator.computer),
    Dashboard("Stock", CupertinoIcons.rectangle_on_rectangle_angled,
        route: RouteGenerator.stock),
    Dashboard("Improvement", CupertinoIcons.rocket,
        route: RouteGenerator.improve),
    Dashboard("Checklist", CupertinoIcons.chevron_down_square,
        route: RouteGenerator.check),
    Dashboard("Check Cctv", CupertinoIcons.checkmark_seal,
        route: RouteGenerator.vendorCheck),
    Dashboard("Application", CupertinoIcons.square_stack_3d_up,
        route: RouteGenerator.other),
    Dashboard("Altai", CupertinoIcons.wifi, route: RouteGenerator.other),
    Dashboard("Handheld", CupertinoIcons.device_laptop,
        route: RouteGenerator.other),
    Dashboard("UPS", CupertinoIcons.battery_25, route: RouteGenerator.other),
    Dashboard("Printer", CupertinoIcons.printer, route: RouteGenerator.other),
    Dashboard("Server", CupertinoIcons.keyboard_chevron_compact_down,
        route: RouteGenerator.other),
    Dashboard("Gate", CupertinoIcons.building_2_fill,
        route: RouteGenerator.other),
    Dashboard("Other", CupertinoIcons.question_circle,
        color: Pallete.green.withOpacity(0.4), route: RouteGenerator.other),
  ];
}
