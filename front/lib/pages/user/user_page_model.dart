import 'package:flutter/cupertino.dart';
import 'package:tutlayt/pages/user/user_page.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';
import 'package:tutlayt/pagination/default_scaffold.dart';

class UserPageModel extends PageModel {
  UserPageModel({Map<String, String?>? params})
      : _params = params,
        super(
          route: RouteUtil.userRoute,
          routePatern: RouteUtil.userRoutePattern,
          title: const Text('User'),
          builder: (context, params) => DefaultScaffold(
            pageModel: UserPageModel(params: params),
          ),
        );

  final Map<String, String?>? _params;

  @override
  Map<String, String?> get params => _params ?? const {'userId': null};

  @override
  Widget get body => UserPage(userId: params['userId']);
}
