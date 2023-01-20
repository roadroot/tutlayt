import 'package:flutter/cupertino.dart';
import 'package:tutlayt/pages/register/register_page.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';

class RegisterPageModel extends PageModel {
  RegisterPageModel()
      : super(
          route: RouteUtil.registerRoute,
          title: const Text('Register'),
        );

  @override
  Widget get body => RegisterPage();
}
