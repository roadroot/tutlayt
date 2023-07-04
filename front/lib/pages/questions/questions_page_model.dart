import 'package:flutter/material.dart';
import 'package:tutlayt/pages/questions/questions_page.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';

class QuestionsPageModel extends PageModel {
  static const String _title = 'Questions';
  const QuestionsPageModel()
      : super(
          route: RouteUtil.questionsRoute,
          title: const Text(_title),
          drawer: const DrawerTile(
            title: Text(_title),
            leading: Icon(Icons.question_answer),
          ),
        );

  @override
  Widget body(Map<String, String?> params) => const QuestionsPage();
}
