import 'package:flutter/material.dart';
import 'package:tutlayt/pages/ask/ask_page_model.dart';
import 'package:tutlayt/pages/home/home_page_model.dart';
import 'package:tutlayt/pages/login/login_page_model.dart';
import 'package:tutlayt/pages/question/question_page_model.dart';
import 'package:tutlayt/pages/questions/questions_page_model.dart';
import 'package:tutlayt/pages/register/register_page_model.dart';
import 'package:tutlayt/pages/user/user_page_model.dart';
import 'package:tutlayt/services/util/util.dart';
import 'package:tutlayt/pagination/page.model.dart';

abstract class RouteUtil {
  static const String loginRoute = "/login";
  static const String homeRoute = "/";
  static const String registerRoute = "/register";
  static const String userRoute = "/user";
  static const String questionsRoute = "/question";
  static const String askRoute = "/ask";
  static final String userRoutePattern =
      "^$userRoute(/(?<userId>${Regex.id.value}))?";
  static final String questionRoutePattern =
      "^${RouteUtil.questionsRoute}/(?<questionId>${Regex.id.value})";

  static List<PageModel> pages = [
    const HomePageModel(),
    LoginPageModel(),
    RegisterPageModel(),
    UserPageModel(),
    QuestionPageModel(),
    const QuestionsPageModel(),
    const AskPageModel(),
  ];

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    String? name = settings.name;
    if (name != null) {
      for (PageModel page in pages) {
        final match = RegExp(page.routePatern).firstMatch(name);
        if (match != null) {
          Map<String, String?> params = {};
          for (String key in page.routeParams) {
            params[key] = match.namedGroup(key);
          }
          return PageRouteBuilder<void>(
            pageBuilder: (context, animation1, animation2) =>
                page.builder(context, params),
            settings: settings,
          );
        }
      }
    }
    return null;
  }
}
