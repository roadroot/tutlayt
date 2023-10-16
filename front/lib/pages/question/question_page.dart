import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutlayt/configuration/config.dart';
import 'package:tutlayt/pages/user/widget/loading.dart';
import 'package:tutlayt/pages/user/widget/user_not_found.dart';
import 'package:tutlayt/ql.dart';
import 'package:tutlayt/services/answer/answer_service.dart';
import 'package:tutlayt/services/question/question.service.dart';

class QuestionPage extends StatelessWidget {
  QuestionPage({super.key, required this.questionId});
  final String questionId;
  final Set<Answer> answers = <Answer>{}.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 2 -
              Config.defaultPageWidth / 2),
      width: Config.defaultPageWidth,
      child: FutureBuilder(
        future: Get.find<QuestionService>().getQuestion(questionId),
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
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          Text(question.body),
                          FutureBuilder(
                              future: Get.find<AnswerService>()
                                  .getAnswers(question.id),
                              builder: (context, snapshot) {
                                final result = snapshot.data;
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return const Loading();
                                }
                                if (result == null) return const Loading();

                                answers.addAll(result);
                                Get.find<AnswerService>()
                                    .subscribeAnswer(question.id)
                                    .listen((answer) {
                                  if (answer != null) {
                                    answers.add(answer);
                                  }
                                });

                                return Obx(
                                  () => answers.isEmpty
                                      ? const Text('No answers yet')
                                      : Column(
                                          children: answers
                                              .expand<Widget>(
                                                (answer) => [
                                                  ListTile(
                                                    title: Text(answer.body),
                                                    subtitle: Text(
                                                        answer.user.username),
                                                    leading: CircleAvatar(
                                                      child: Text(answer
                                                          .user.username[0]),
                                                    ),
                                                  ),
                                                  const Divider(),
                                                ],
                                              )
                                              .toList(),
                                        ),
                                );
                              }),
                          // answer input
                          TextField(
                            onSubmitted: (body) async {
                              await Get.find<AnswerService>().answerQuestion(
                                  questionId: questionId, body: body);
                            },
                            decoration: InputDecoration(
                              hintText: 'Answer',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ]);
        },
      ),
    );
  }
}
