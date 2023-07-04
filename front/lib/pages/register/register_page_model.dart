import 'package:flutter/cupertino.dart';
import 'package:tutlayt/pages/register/register_page.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';

class RegisterPageModel extends PageModel {
  RegisterPageModel()
      : super(
            route: RouteUtil.registerRoute,
            title: const Text('Register'),
            drawer: const DrawerTile(
              title: Text('Register'),
              leading: Icon(CupertinoIcons.person_badge_plus),
            ));

  @override
  Widget body(Map<String, String?> params) => RegisterPage();
}
