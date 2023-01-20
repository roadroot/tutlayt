import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutlayt/pagination/default_scaffold.dart';

abstract class PageModel {
  const PageModel({
    required this.route,
    required this.title,
    this.drawer,
    Widget Function(BuildContext context, Map<String, String?> params)? builder,
    String? routePatern,
  })  : _builder = builder,
        _routePatern = routePatern;
  final String route;
  final String? _routePatern;
  String get routePatern => _routePatern ?? '^$route\$';
  final Widget title;
  Widget get body;
  final DrawerTile? drawer;
  final Widget Function(BuildContext context, Map<String, String?> params)?
      _builder;

  get builder => _builder ?? defaultBuilder;

  Map<String, String?> get params => const {};

  Widget defaultBuilder(BuildContext context, Map<String, String?> params) {
    return DefaultScaffold(route: route);
  }
}

class DrawerTile {
  const DrawerTile({this.title, this.leading, this.trailing});
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
}
