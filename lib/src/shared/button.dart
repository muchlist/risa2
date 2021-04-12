import 'package:flutter/material.dart';

class RisaButton extends StatelessWidget {
  final String title;
  final GestureTapCallback onPress;
  final bool disabled;

  RisaButton(
      {required this.title, required this.onPress, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      width: double.infinity,
      child: ElevatedButton(
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: !disabled ? onPress : null,
        style: ElevatedButton.styleFrom(
            primary: !disabled ? Theme.of(context).accentColor : Colors.grey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            padding: const EdgeInsets.all(10.0)),
      ),
    );
  }
}
