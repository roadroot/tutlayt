import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageModel {
  const PageModel(this.route, this.title, this.drawer, this.body);
  final String route;
  final Widget title;
  final Widget body;
  final DrawerTile drawer;
}

class DrawerTile {
  const DrawerTile({this.title, this.leading, this.trailing});
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
}
