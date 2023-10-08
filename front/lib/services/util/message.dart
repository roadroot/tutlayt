import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Message {
  info(Colors.blue),
  warning(Colors.yellow),
  error(Colors.red),
  regular(Colors.black),
  success(Colors.green);

  final Color _color;

  static void clear() {
    Get.closeAllSnackbars();
  }

  showWidget(Widget message) {
    Get.closeAllSnackbars();
    Get.showSnackbar(GetSnackBar(
      backgroundColor: _color,
      titleText: message,
    ));
  }

  show(String message) {
    Get.closeAllSnackbars();
    Get.showSnackbar(GetSnackBar(
      backgroundColor: _color,
      title: message,
    ));
  }

  const Message(this._color);
}
