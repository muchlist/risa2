import 'package:flutter/material.dart';

class DisableOverScrollGlow extends StatelessWidget {
  const DisableOverScrollGlow({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return false;
        },
        child: child);
  }
}
