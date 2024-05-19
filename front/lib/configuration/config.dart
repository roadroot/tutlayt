import 'package:flutter/material.dart';

abstract class Config {
  static const double loginPanelWidth = 350;
  static const double defaultPageWidth = 800;

  static double getMargin(BuildContext context) =>
      MediaQuery.of(context).size.width / 2 - Config.defaultPageWidth / 2;
}
