import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tutlayt/ql.dart';

class AnswerService {
  Future<Answer?> answerQuestion({
    required String questionId,
    required String body,
    List<http.MultipartFile>? files,
  }) async {
    return await Get.find<Mutation>().createAnswer(const AnswerSelector(),
        AnswerData(questionId: questionId, body: body, files: files));
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

  Stream<Answer?> subscribeAnswer(String answerId) {
    return Get.find<Subscription>()
        .answerAdded(const AnswerSelector(), answerId);
  }
}
