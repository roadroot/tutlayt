import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tutlayt/pages/user/widget/loading.dart';
import 'package:tutlayt/pages/user/widget/user_not_found.dart';
import 'package:tutlayt/services/question/question.service.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key, required this.questionId});
  final String questionId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 150),
      width: MediaQuery.of(context).size.width - 150,
      child: FutureBuilder(
        future: GetIt.I<QuestionService>().getQuestion(questionId),
        builder: (context, snapshot) {
          final question = snapshot.data;
          return snapshot.connectionState != ConnectionState.done
              ? const Loading()
              : question == null
                  ? const UserNotFound()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question.title,
                            style: Theme.of(context).textTheme.headlineMedium),
                        Text(question.body),
                      ],
                    );
        },
      ),
    );
  }
}
