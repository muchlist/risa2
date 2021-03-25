import 'package:flutter/material.dart';
import 'package:risa2/src/models/improve.dart';

class ImproveModel extends ChangeNotifier {
  List<Improve> _improveList = [
    Improve(
        title: "Update IOS PPU Pandu",
        description:
            "Update sebanyak 57 tablet pandu di lingkungan pelindo III",
        progress: 97),
    Improve(
        title: "Maintnenace UPS",
        description: "Maintenance seluruh perangkat ups",
        progress: 50),
  ];

  List<Improve> get improveList {
    return [..._improveList];
  }
}
