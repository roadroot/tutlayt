import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutlayt/pagination/default_scaffold.dart';

abstract class PageModel {
  const PageModel({
    required this.title,
    this.route,
    this.onlyWhenConnected = false,
    this.onlyWhenDisonnected = false,
    this.drawer,
    Function(BuildContext context, Map<String, Object?> params)? onTap,
    Widget Function(BuildContext context, Map<String, String?> params)? builder,
    String? routePatern,
  })  : _builder = builder,
        _routePatern = routePatern,
        _onTap = onTap;
  final String? route;
  final String? _routePatern;
  String get routePatern => _routePatern ?? '^$route\$';
  final Widget title;
  final DrawerTile? drawer;
  final Function(BuildContext context, Map<String, Object?> params)? _onTap;
  Function(BuildContext context, Map<String, Object?> params) get onTap =>
      _onTap ??
      (context, params) async {
        await Navigator.pushNamed(context, route!, arguments: params);
      };
  final Widget Function(BuildContext context, Map<String, String?> params)?
      _builder;

  final bool onlyWhenConnected;
  final bool onlyWhenDisonnected;

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
