import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeLikeButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final GestureTapCallback tapTap;

  const HomeLikeButton(
      {required this.iconData, required this.text, required this.tapTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(24)),
        child: Text.rich(TextSpan(children: [
          WidgetSpan(
              child: Icon(
            iconData,
            size: 21,
            color: Colors.white,
          )),
          TextSpan(
              text: text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500))
        ])),
      ),
    );
  }
}
