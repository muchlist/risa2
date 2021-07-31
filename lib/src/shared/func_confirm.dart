import 'package:flutter/material.dart';

Future<bool?> getConfirm(BuildContext context, String title, String detail) {
  return showDialog<bool?>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(detail),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor),
                child: const Text("Tidak"),
                onPressed: () => Navigator.of(context).pop(false)),
            TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Ya"))
          ],
        );
      });
}
