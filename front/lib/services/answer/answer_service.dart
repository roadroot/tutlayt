import 'package:get_it/get_it.dart';
import 'package:tutlayt/ql.dart';

class AnswerService {
  Future<Answer?> answerQuestion(
      {required String questionId, required String body}) async {
    return await GetIt.I<Mutation>().createAnswer(
        const AnswerSelector(), AnswerData(questionId: questionId, body: body));
  }

  Future<Answer?> getAnswer(String answerId) async {
    return await GetIt.I<Query>().answer(const AnswerSelector(), answerId);
  }

  Future<List<Answer>?> getAnswers(String questionId) async {
    return (await GetIt.I<Query>()
            .answers(const AnswerPageSelector(), 20, null, questionId, null))
        .nodes
        .toList();
  }
}
