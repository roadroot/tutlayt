import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tutlayt/pages/questions/questions_page.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';

class QuestionsPageModel extends PageModel {
  static const String _title = 'Questions';

  QuestionsPageModel()
      : super(
          route: Routes.question.segments,
          title: const Text(_title),
          drawer: const DrawerTile(
            title: Text(_title),
            leading: Icon(Icons.question_answer),
          ),
        );

  @override
  Widget body(Uri uri) => const QuestionsPage();

  @override
  bool canHandle(Uri uri) {
    if (route == null) {
      logger.warning('Route $runtimeType is null');
      return false;
    }
    return listEquals(uri.pathSegments, route);
  }
}
