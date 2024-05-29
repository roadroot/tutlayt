import 'package:flutter/cupertino.dart';
import 'package:tutlayt/pages/user/user_page.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';

class UserPageModel extends PageModel {
  UserPageModel()
      : super(
          route: Routes.user.segments,
          title: const Text('User'),
        );

  @override
  Widget body(Uri uri) => UserPage(userId: uri.queryParameters['userId']);
}
