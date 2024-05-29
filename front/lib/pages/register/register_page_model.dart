import 'package:flutter/cupertino.dart';
import 'package:tutlayt/pages/register/register_page.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';

class RegisterPageModel extends PageModel {
  RegisterPageModel()
      : super(
          route: Routes.register.segments,
          title: const Text('Register'),
          drawer: const DrawerTile(
            title: Text('Register'),
            leading: Icon(CupertinoIcons.person_badge_plus),
          ),
          onlyWhenDisonnected: true,
        );

  @override
  Widget body(Uri uri) => RegisterPage();
}
