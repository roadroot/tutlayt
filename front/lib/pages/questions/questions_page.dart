import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tutlayt/configuration/config.dart';
import 'package:tutlayt/pages/user/widget/loading.dart';
import 'package:tutlayt/pages/user/widget/user_not_found.dart';
import 'package:tutlayt/services/question/question.service.dart';

class QuestionsPage extends StatelessWidget {
  const QuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Config.defaultPageWidth,
        child: FutureBuilder(
          future: GetIt.I<QuestionService>().getQuestions(),
          builder: (context, snapshot) {
            return snapshot.connectionState != ConnectionState.done
                ? const Loading()
                : snapshot.data == null
                    ? const UserNotFound()
                    : ListView(
                        children: snapshot.data!
                            .expand<Widget>(
                              (question) => [
                                ListTile(
                                  title: Text(question.title),
                                  subtitle: Text(
                                      '${question.body.substring(0, min(question.body.length, 100))}${question.body.length < 100 ? '' : '...'}'),
                                  leading: CircleAvatar(
                                    child: Text(question.title[0]),
                                  ),
                                  onTap: () => Navigator.of(context)
                                      .pushNamed('/question/${question.id}'),
                                ),
                                const Divider(),
                              ],
                            )
                            .toList()
                          ..insert(0, const Divider()),
                      );
          },
        ),
      ),
    );
  }
}
