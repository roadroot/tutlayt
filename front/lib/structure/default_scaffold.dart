import 'package:flutter/material.dart';
import 'package:tutlayt/helper/util.dart';
import 'package:tutlayt/pages/login.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../pages/registration.dart';

class DefaultScaffold extends StatelessWidget {
  const DefaultScaffold(this.route, {super.key});

  final String route;
  static List<PageModel> pages = [
    PageModel(
        route: 'login',
        title: const Text('Login'),
        drawer:
            const DrawerTile(title: Text('Login'), leading: Icon(Icons.person)),
        body: Login()),
    PageModel(
        route: 'registration',
        title: const Text('Registration'),
        drawer: const DrawerTile(
            title: Text('Registration'), leading: Icon(Icons.person)),
        body: Registration()),
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
    return Scaffold(
      appBar: AppBar(
        title: page.title,
      ),
      body: page.body,
      drawer: FutureBuilder(
          future: SecuredStore().user,
          builder: (context, user) {
            final widgets = pages
                .map<Widget>((page) => ListTile(
                      title: page.drawer.title,
                      leading: page.drawer.leading,
                      trailing: page.drawer.trailing,
                      selected: route == page.route,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation, animation2) =>
                                DefaultScaffold(page.route)),
                      ),
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
