import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  const TextIcon({Key? key, required this.icon, required this.text})
      : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <InlineSpan>[
          WidgetSpan(
            child: Icon(
              icon,
              size: 18,
              color: Colors.grey,
            ),
          ),
          TextSpan(
            text: " $text",
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
