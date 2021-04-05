import 'package:flutter/material.dart';
import 'package:risa2/src/config/pallatte.dart';

class Dashboard {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  const Dashboard(this.title, this.icon,
      {this.color = Pallete.green, this.route = ""});
}
