import 'package:flutter/cupertino.dart';

IconData getIcon(String category) {
  switch (category.toLowerCase()) {
    case "cctv":
      return CupertinoIcons.camera;
    case "stock":
      return CupertinoIcons.rectangle_on_rectangle_angled;
    case "pc":
      return CupertinoIcons.desktopcomputer;
    case "application":
      return CupertinoIcons.square_stack_3d_up;
    case "ups":
      return CupertinoIcons.battery_25;
    case "printer":
      return CupertinoIcons.printer;
    case "handheld":
      return CupertinoIcons.device_laptop;
    case "altai":
      return CupertinoIcons.wifi;
    case "server":
      return CupertinoIcons.keyboard_chevron_compact_down;
    case "gate":
      return CupertinoIcons.building_2_fill;
    default:
      return CupertinoIcons.smallcircle_circle;
  }
}
