import 'package:flutter/material.dart';
import 'package:tutlayt/pagination/page.model.dart';

class DefaultScaffold extends StatelessWidget {
  const DefaultScaffold(this.route, {super.key});

  final String route;
  static const List<PageModel> pages = [
    PageModel(
        'a',
        Text('a'),
        DrawerTile(title: Text('a'), leading: Icon(Icons.access_alarm_rounded)),
        Text('a')),
    PageModel('b', Text('b'), DrawerTile(title: Text('b')), Text('b')),
    PageModel('c', Text('c'), DrawerTile(title: Text('c')), Text('c')),
    PageModel('d', Text('d'), DrawerTile(title: Text('d')), Text('d')),
    PageModel('e', Text('e'), DrawerTile(title: Text('e')), Text('e')),
    PageModel('f', Text('f'), DrawerTile(title: Text('f')), Text('f')),
  ];

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return Map.fromEntries(pages.map((page) =>
        MapEntry(page.route, (context) => DefaultScaffold(page.route))));
  }

  PageModel getPage(String route) {
    return pages.firstWhere((page) => page.route == route);
  }

  @override
  Widget build(BuildContext context) {
    PageModel page = getPage(route);
    return Hero(
      tag: '',
      child: Scaffold(
        appBar: AppBar(
          title: page.title,
        ),
        body: page.body,
        drawer: Drawer(
            child: ListView(
          children: pages
              .map((page) => ListTile(
                    title: page.drawer.title,
                    leading: page.drawer.leading,
                    trailing: page.drawer.trailing,
                    selected: route == page.route,
                    onTap: (() =>
                        Navigator.pushReplacementNamed(context, page.route)),
                  ))
              .toList(),
        )),
      ),
    );
  }
}
