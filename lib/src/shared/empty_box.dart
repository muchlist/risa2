import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyBox extends StatelessWidget {
  final GestureTapCallback loadTap;

  const EmptyBox({required this.loadTap});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
      onTap: loadTap,
      child: SizedBox(
          width: 200,
          height: 200,
          child: Lottie.asset('assets/lottie/629-empty-box.json')),
    ));
  }
}
