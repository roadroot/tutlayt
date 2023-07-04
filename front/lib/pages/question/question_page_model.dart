import 'package:flutter/material.dart';
import 'package:tutlayt/pages/question/question_page.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';

class QuestionPageModel extends PageModel {
  static const String _title = 'Question';

  QuestionPageModel()
      : super(
          route: RouteUtil.questionRoutePattern,
          title: const Text(_title),
        );

  @override
  List<String> get routeParams => ['questionId'];

  @override
  Widget body(Map<String, String?> params) =>
      QuestionPage(questionId: params['questionId']!);
}
