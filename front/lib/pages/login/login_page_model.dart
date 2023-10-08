import 'package:flutter/cupertino.dart';
import 'package:tutlayt/pages/login/login_page.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';

class LoginPageModel extends PageModel {
  LoginPageModel()
      : super(
          route: RouteUtil.loginRoute,
          title: const Text('Login'),
          drawer: const DrawerTile(
            title: Text('Login'),
            leading: Icon(CupertinoIcons.person),
          ),
          onlyWhenDisonnected: true,
        );

  @override
  Widget body(Map<String, String?> params) => LoginPage();
}
