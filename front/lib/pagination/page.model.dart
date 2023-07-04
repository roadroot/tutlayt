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
  final DrawerTile? drawer;
  final Widget Function(BuildContext context, Map<String, String?> params)?
      _builder;

  Widget Function(BuildContext, Map<String, String?>) get builder =>
      _builder ?? defaultBuilder;

  List<String> get routeParams => const [];
  Widget body(Map<String, String?> params);

  Widget defaultBuilder(BuildContext context, Map<String, String?> params) {
    return DefaultScaffold(route: route, params: params);
  }
}

class DrawerTile {
  const DrawerTile({this.title, this.leading, this.trailing});
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
}
