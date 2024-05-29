import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tutlayt/pages/question/question_page.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';

class QuestionPageModel extends PageModel {
  static const String _title = 'Question';

  QuestionPageModel()
      : super(
          route: Routes.question.segments,
          title: const Text(_title),
        );

  @override
  Widget body(Uri uri) =>
      QuestionPage(questionId: uri.pathSegments[route!.length]);

  @override
  bool canHandle(Uri uri) {
    if (route == null) {
      logger.warning('Route $runtimeType is null');
      return false;
    }

    return route!.length + 1 == uri.pathSegments.length &&
        listEquals(uri.pathSegments.sublist(0, route!.length), route!);
  }
}
