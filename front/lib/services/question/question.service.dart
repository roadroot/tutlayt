import 'package:get/get.dart';
import 'package:tutlayt/ql.dart';

class QuestionService {
  Future<List<Question>?> getQuestions() async {
    return (await Get.find<Query>().questions(
            const QuestionPageSelector(
                nodes: QuestionSelector(user: UserSelector())),
            20,
            null))
        .nodes
        .toList();
  }

  Future<Question?> askQuestion(
      {required String title, required String body, Set<String>? tags}) async {
    return await Get.find<Mutation>().createQuestion(
        const QuestionSelector(), QuestionData(title: title, body: body));
  }

  Future<Question?> getQuestion(String id) async {
    return await Get.find<Query>()
        .question(const QuestionSelector(user: UserSelector()), id);
  }
}
