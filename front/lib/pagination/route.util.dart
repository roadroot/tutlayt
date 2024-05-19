import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutlayt/pages/ask/ask_page_model.dart';
import 'package:tutlayt/pages/disconnect/disconnect_page_model.dart';
import 'package:tutlayt/pages/home/home_page_model.dart';
import 'package:tutlayt/pages/login/login_page_model.dart';
import 'package:tutlayt/pages/question/question_page_model.dart';
import 'package:tutlayt/pages/questions/questions_page_model.dart';
import 'package:tutlayt/pages/register/register_page_model.dart';
import 'package:tutlayt/pages/user/user_page_model.dart';
import 'package:tutlayt/services/controller.dart';
import 'package:tutlayt/pagination/page.model.dart';

enum Routes {
  login(['login']),
  home([]),
  register(['register']),
  user(['user']),
  question(['question']),
  ask(['ask']);

  const Routes(this.segments);
  final List<String> segments;

  static List<PageModel> allPages = [
    HomePageModel(),
    LoginPageModel(),
    RegisterPageModel(),
    UserPageModel(),
    QuestionPageModel(),
    QuestionsPageModel(),
    AskPageModel(),
    DisconenctPageModel(),
  ];

  static List<PageModel> get routedPages =>
      allPages.where((e) => e.route != null).toList(growable: false);

  static List<PageModel> get pages => Get.find<Controller>().connected
      ? allPages.where((element) => !element.onlyWhenDisonnected).toList()
      : allPages.where((element) => !element.onlyWhenConnected).toList();

  static Route? onGenerateRoute(RouteSettings settings) {
    String? name = settings.name;
    if (name == null) return null;
    Uri uri = Uri.parse(name);
    PageModel page = routedPages.where((e) => e.canHandle(uri)).firstOrNull!;
    return PageRouteBuilder<void>(
      pageBuilder: (ctx, a1, a2) => page.builder(ctx, uri),
      settings: settings,
    );
  }

  @override
  String toString() => assemble(segments);

  static String assemble(List<String> route) => '/${route.join('/')}';
}
