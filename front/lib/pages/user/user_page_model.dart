import 'package:flutter/cupertino.dart';
import 'package:tutlayt/pages/user/user_page.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';
import 'package:tutlayt/pagination/default_scaffold.dart';

class UserPageModel extends PageModel {
  UserPageModel()
      : super(
          route: RouteUtil.userRoute,
          routePatern: RouteUtil.userRoutePattern,
          title: const Text('User'),
          builder: (context, params) => DefaultScaffold(
            pageModel: UserPageModel(),
            params: params,
          ),
        );

  @override
  List<String> get routeParams => const ['userId'];

  @override
  Widget body(Map<String, String?> params) =>
      UserPage(userId: params['userId']);
}
