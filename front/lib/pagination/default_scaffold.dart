import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';
import 'package:tutlayt/ql.dart';
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
            User? data = user.data;
            if (data != null) {
              widgets.insert(
                0,
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    RouteUtil.userRoute,
                  ),
                  child: DrawerHeader(
                    decoration: const BoxDecoration(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          elevation: 25,
                          shape: const CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade100,
                            foregroundImage: NetworkImage(data.picture ?? ''),
                            maxRadius: 40,
                          ),
                        ),
                        Text(
                          data.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data.email,
                          style:
                              TextStyle(color: Theme.of(context).disabledColor),
                        ),
                      ],
                    ),
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
