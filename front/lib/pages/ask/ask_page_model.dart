import 'package:flutter/material.dart';
import 'package:tutlayt/pages/ask/ask_page.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';

class AskPageModel extends PageModel {
  const AskPageModel()
      : super(
          route: RouteUtil.askRoute,
          title: const Text('Ask a question'),
          drawer: const DrawerTile(
            title: Text('Ask a question'),
            leading: Icon(Icons.info),
          ),
          onlyWhenConnected: true,
        );

  @override
  Widget body(Map<String, String?> params) => AskPage();
}
