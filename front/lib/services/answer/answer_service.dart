import 'package:get/get.dart';
import 'package:tutlayt/ql.dart';

class AnswerService {
  Future<Answer?> answerQuestion(
      {required String questionId, required String body}) async {
    return await Get.find<Mutation>().createAnswer(
        const AnswerSelector(), AnswerData(questionId: questionId, body: body));
  }

  Future<Answer?> getAnswer(String answerId) async {
    return await Get.find<Query>().answer(const AnswerSelector(), answerId);
  }

  Future<List<Answer>?> getAnswers(String questionId) async {
    return (await Get.find<Query>()
            .answers(const AnswerPageSelector(), 20, null, questionId, null))
        .nodes
        .toList();
  }
}
