import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tutlayt/configuration/config.dart';
import 'package:tutlayt/pages/question/answer.dart';
import 'package:tutlayt/pages/question/question/question_widget.dart';
import 'package:tutlayt/pages/user/widget/loading.dart';
import 'package:tutlayt/pages/user/widget/user_not_found.dart';
import 'package:tutlayt/ql.dart';
import 'package:tutlayt/services/answer/answer_service.dart';
import 'package:tutlayt/services/question/question.service.dart';
import 'package:tutlayt/widget/card.dart';

class QuestionPage extends StatefulWidget {
  final String questionId;
  final Set<Answer> answers = <Answer>{};
  final Stream<Answer> answerStream;

  QuestionPage({super.key, required this.questionId})
      : answerStream = Get.find<AnswerService>()
            .subscribeAnswer(questionId)
            .where((event) => event != null)
            .cast<Answer>();

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  bool loading = true;
  bool questionNotFound = false;

  @override
  void initState() {
    super.initState();

    Get.find<AnswerService>().getAnswers(widget.questionId).then((value) {
      setState(() => loading = false);

      if (value == null) return;

      setState(() {
        widget.answers.addAll(value);
      });
    });

    widget.answerStream.listen((event) {
      setState(() {
        widget.answers.add(event);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Loading();
    }
    return Container(
      margin: EdgeInsets.only(left: Config.getMargin(context)),
      width: Config.defaultPageWidth,
      child: FutureBuilder(
        future: Get.find<QuestionService>().getQuestion(widget.questionId),
        builder: (context, snapshot) {
          final question = snapshot.data;
          return snapshot.connectionState != ConnectionState.done
              ? const Loading()
              : question == null
                  ? const UserNotFound()
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: widget.answers.length + 2,
                      itemBuilder: (contexy, index) {
                        if (index == widget.answers.length + 1) {
                          return QuestionWidget(question: question);
                        }
                        if (index == 0) {
                          return AnswerField(
                            onSubmitted: (String answer,
                                List<http.MultipartFile> files) async {
                              await Get.find<AnswerService>().answerQuestion(
                                questionId: widget.questionId,
                                body: answer,
                                files: files
                              );
                            },
                          );
                        }
                        return CustomCard(
                          child: ListTile(
                            title: Markdown(
                              data: widget.answers.elementAt(index - 1).body,
                              shrinkWrap: true,
                            ),
                            subtitle: Text(
                              widget.answers.elementAt(index - 1).user.username,
                            ),
                          ),
                        );
                      },
                    );
        },
      ),
    );
  }
}
