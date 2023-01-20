import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tutlayt/pagination/route.util.dart';
import 'package:tutlayt/services/user/user.service.dart';

class DefaultScaffold extends StatelessWidget {
  const DefaultScaffold({this.route, this.pageModel, super.key, this.body})
      : assert(
            pageModel == null && route != null ||
                pageModel != null && route == null,
            "Must specify a pageModel or route but not both.");

  final Widget? body;
  final PageModel? pageModel;

  final String? route;

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return Map.fromEntries(RouteUtil.pages.map((page) =>
        MapEntry(page.route, (context) => DefaultScaffold(route: page.route))));
  }

  PageModel getPage(String route) {
    return RouteUtil.pages.firstWhere((page) => page.route == route);
  }

  @override
  Widget build(BuildContext context) {
    PageModel page = pageModel ?? getPage(route!);
    return Scaffold(
      appBar: AppBar(
        title: page.title,
      ),
      body: body ?? page.body,
      drawer: FutureBuilder(
          future: GetIt.I<UserService>().user,
          builder: (context, user) {
            final widgets = RouteUtil.pages
                .where((element) => element.drawer != null)
                .map<Widget>((page) => ListTile(
                      title: page.drawer!.title,
                      leading: page.drawer!.leading,
                      trailing: page.drawer!.trailing,
                      selected: route == page.route,
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, page.route),
                    ))
                .toList();
            if (user.hasData) {
              widgets.insert(
                0,
                DrawerHeader(
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 75,
                        width: 75,
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(user.data!.username,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          user.hasData
                              ? user.data!.email
                              : AppLocalizations.of(context)!.loading,
                          style: TextStyle(
                              color: Theme.of(context).disabledColor)),
                    ],
                  ),
                ),
              );
            }
            return Drawer(
                child: ListView(
              children: widgets,
            ));
          }),
    );
  }
}
