import 'package:flutter/material.dart';

class IncDecIcon extends StatelessWidget {
  const IncDecIcon({Key? key, required this.value}) : super(key: key);
  final int value;

  Text getTextvalue() {
    if (value >= 0) {
      return Text(
        "+$value",
        style: const TextStyle(color: Colors.green, fontSize: 12),
      );
    }
    return Text(
      value.toString(),
      style: const TextStyle(color: Colors.red, fontSize: 12),
    );
  }

  Icon getIcon() {
    if (value >= 0) {
      return const Icon(
        Icons.arrow_circle_up_outlined,
        color: Colors.green,
      );
    }
    return const Icon(
      Icons.arrow_circle_down_outlined,
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[getIcon(), getTextvalue()],
    );
  }
}
