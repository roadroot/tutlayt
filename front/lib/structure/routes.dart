import 'package:flutter/material.dart';
import 'package:tutlayt/pages/login/login.dart';
import 'package:tutlayt/pages/register/registration.dart';
import 'package:tutlayt/pagination/page.model.dart';

class RouteUtils {
  static const String loginRoute = "/login";
  static const String homeRoute = loginRoute; // TODO: implement '/'
  static const String registerRoute = "/register";

  static List<PageModel> pages = [
    PageModel(
        route: loginRoute,
        title: const Text('Login'),
        drawer:
            const DrawerTile(title: Text('Login'), leading: Icon(Icons.person)),
        body: Login()),
    PageModel(
        route: registerRoute,
        title: const Text('Register'),
        drawer: const DrawerTile(
            title: Text('Register'), leading: Icon(Icons.person_add)),
        body: Register()),
  ];
}
