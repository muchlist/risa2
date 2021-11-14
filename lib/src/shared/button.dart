import 'package:flutter/material.dart';
import 'package:risa2/src/config/pallatte.dart';

class RisaButton extends StatelessWidget {
  const RisaButton(
      {required this.title, required this.onPress, this.disabled = false});
  final String title;
  final GestureTapCallback onPress;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !disabled ? onPress : null,
        style: ElevatedButton.styleFrom(
            primary: !disabled
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            padding: const EdgeInsets.all(10.0)),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton(
      {required this.iconData,
      required this.text,
      required this.tapTap,
      this.color = Pallete.green});

  final IconData iconData;
  final String text;
  final GestureTapCallback tapTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
        child: Text.rich(TextSpan(children: <InlineSpan>[
          WidgetSpan(
              child: Icon(
            iconData,
            size: 21,
            color: Colors.white,
          )),
          TextSpan(
              text: " $text",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500)),
        ])),
      ),
    );
  }
}
