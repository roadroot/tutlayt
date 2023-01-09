import 'package:flutter/material.dart';

enum Message {
  info(Colors.blue),
  warning(Colors.yellow),
  error(Colors.red),
  regular(Colors.black),
  success(Colors.green);

  final Color _color;

  static void clear(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  showWidget(BuildContext context, Widget message) {
    clear(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: message,
      backgroundColor: _color,
    ));
  }

  show(BuildContext context, String message) {
    showWidget(context, Text(message));
  }

  const Message(this._color);
}
