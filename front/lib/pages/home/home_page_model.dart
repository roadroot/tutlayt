import 'package:flutter/material.dart';
import 'package:tutlayt/pages/home/home_page.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';

class HomePageModel extends PageModel {
  const HomePageModel()
      : super(
          route: RouteUtil.homeRoute,
          title: const Text('Home'),
          drawer:
              const DrawerTile(title: Text('Home'), leading: Icon(Icons.home)),
        );

  @override
  Widget body(Map<String, String?> params) => const HomePage();
}
