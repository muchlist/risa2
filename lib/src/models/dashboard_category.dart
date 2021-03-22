import 'package:flutter/material.dart';

class DashboardItem {
  final String title;
  final IconData icon;
  final Color color;

  const DashboardItem(this.title, this.icon,
      {this.color = const Color(0xff4643D3)});
}
