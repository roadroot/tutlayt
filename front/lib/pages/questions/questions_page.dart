import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:tutlayt/pages/user/widget/loading.dart';
import 'package:tutlayt/pages/user/widget/user_not_found.dart';
import 'package:tutlayt/services/question/question.service.dart';

class QuestionsPage extends StatelessWidget {
  const QuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    GetIt.I<QuestionService>().getQuestions().then((value) {
      print(value);
    });
    return FutureBuilder(
      future: GetIt.I<QuestionService>().getQuestions(),
      builder: (context, snapshot) {
        return Center(
          child: snapshot.connectionState != ConnectionState.done
              ? const Loading()
              : snapshot.data == null
                  ? const UserNotFound()
                  : ListView(
                      children: snapshot.data!
                          .map<Widget>(
                            (question) => Text(question.title),
                          )
                          .toList(),
                    ),
        );
      },
    );
  }
}
