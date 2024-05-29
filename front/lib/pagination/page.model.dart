import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:tutlayt/pagination/default_scaffold.dart';

abstract class PageModel {
  Logger get logger => Logger(runtimeType.toString());

  const PageModel({
    required this.title,
    this.route,
    this.onlyWhenConnected = false,
    this.onlyWhenDisonnected = false,
    this.drawer,
    Function(BuildContext, Uri)? onTap,
    Widget Function(BuildContext, Uri)? builder,
  })  : _builder = builder,
        _onTap = onTap;

  final List<String>? route;
  final Widget title;
  final DrawerTile? drawer;
  final Function(BuildContext context, Uri uri)? _onTap;
  Function(BuildContext context, Uri uri) get onTap =>
      _onTap ??
      (context, params) async {
        await Navigator.pushNamed(context, '/${route!.join('/')}',
            arguments: params);
      };
  final Widget Function(BuildContext, Uri)? _builder;

  final bool onlyWhenConnected;
  final bool onlyWhenDisonnected;

  bool canHandle(Uri uri) {
    if (route == null) {
      logger.warning('Route $runtimeType is null');
      return false;
    }

    return listEquals(uri.pathSegments, route!);
  }

  Widget Function(BuildContext, Uri) get builder => _builder ?? defaultBuilder;

  Widget body(Uri uri);

  Widget defaultBuilder(BuildContext context, Uri uri) =>
      DefaultScaffold(uri: uri);
}

class DrawerTile {
  const DrawerTile({this.title, this.leading, this.trailing});
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
}
