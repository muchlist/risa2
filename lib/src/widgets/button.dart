import 'package:flutter/material.dart';

class RisaButton extends StatelessWidget {
  final String title;
  final GestureTapCallback onPress;

  RisaButton({required this.title, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      width: double.infinity,
      child: ElevatedButton(
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).buttonColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            padding: EdgeInsets.all(15.0)),
      ),
    );
  }
}
