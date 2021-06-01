import 'package:flutter/material.dart';

class IncDecIcon extends StatelessWidget {
  final int value;

  const IncDecIcon({Key? key, required this.value}) : super(key: key);

  Text getTextvalue() {
    if (value >= 0) {
      return Text(
        "+$value",
        style: TextStyle(color: Colors.green, fontSize: 12),
      );
    }
    return Text(
      value.toString(),
      style: TextStyle(color: Colors.red, fontSize: 12),
    );
  }

  Icon getIcon() {
    if (value >= 0) {
      return Icon(
        Icons.arrow_circle_up_outlined,
        color: Colors.green,
      );
    }
    return Icon(
      Icons.arrow_circle_down_outlined,
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [getIcon(), getTextvalue()],
    );
  }
}
