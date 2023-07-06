import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tutlayt/configuration/config.dart';
import 'package:tutlayt/pages/user/widget/loading.dart';
import 'package:tutlayt/pages/user/widget/user_not_found.dart';
import 'package:tutlayt/services/answer/answer_service.dart';
import 'package:tutlayt/services/question/question.service.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key, required this.questionId});
  final String questionId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 2 -
              Config.defaultPageWidth / 2),
      width: Config.defaultPageWidth,
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
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          Text(question.body),
                          FutureBuilder(
                            future: GetIt.I<AnswerService>()
                                .getAnswers(question.id),
                            builder: (context, snapshot) {
                              final answers = snapshot.data;
                              return snapshot.connectionState !=
                                      ConnectionState.done
                                  ? const Loading()
                                  : answers == null
                                      ? const Loading()
                                      : answers.isEmpty
                                          ? const Text('No answers yet')
                                          : Column(
                                              children: answers
                                                  .expand<Widget>(
                                                    (answer) => [
                                                      ListTile(
                                                        title:
                                                            Text(answer.body),
                                                        subtitle: Text(answer
                                                            .user.username),
                                                        leading: CircleAvatar(
                                                          child: Text(answer
                                                              .user
                                                              .username[0]),
                                                        ),
                                                      ),
                                                      const Divider(),
                                                    ],
                                                  )
                                                  .toList(),
                                            );
                            },
                          ),
                          // answer input
                          TextField(
                            onSubmitted: (body) async {
                              await GetIt.I<AnswerService>().answerQuestion(
                                  questionId: questionId, body: body);
                              // TODO remove this and replace with subscription
                              Navigator.of(context).pushReplacementNamed(
                                  '/question/$questionId');
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
