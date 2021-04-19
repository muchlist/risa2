import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/config/pallatte.dart';

Flushbar showToastError(
    {required BuildContext context,
    required String message,
    bool onTop = false}) {
  return Flushbar(
    message: message,
    duration: Duration(seconds: 5),
    backgroundColor: Colors.red.shade300,
    flushbarPosition: onTop ? FlushbarPosition.TOP : FlushbarPosition.BOTTOM,
  )..show(context);
}

Flushbar showToastSuccess(
    {required BuildContext context,
    required String message,
    bool onTop = false}) {
  return Flushbar(
    message: message,
    duration: Duration(seconds: 5),
    backgroundColor: Pallete.green,
    borderColor: Colors.white,
    flushbarPosition: onTop ? FlushbarPosition.TOP : FlushbarPosition.BOTTOM,
  )..show(context);
}

Flushbar showToastWarning(
    {required BuildContext context,
    required String message,
    bool onTop = false}) {
  return Flushbar(
    message: message,
    duration: Duration(seconds: 5),
    backgroundColor: Colors.deepOrange.shade400,
    flushbarPosition: onTop ? FlushbarPosition.TOP : FlushbarPosition.BOTTOM,
  )..show(context);
}
