import 'package:get_it/get_it.dart';
import 'package:tutlayt/ql.dart';

class QuestionService {
  Future<List<Question>?> getQuestions() async {
    var a = await GetIt.I<Query>().questions(
        const QuestionPageSelector(
            nodes: QuestionSelector(user: UserSelector())),
        20,
        null);
    return (a)?.nodes?.toList();
  }

  Future<Question?> askQuestion(
      {required String title, required String body, Set<String>? tags}) async {
    return await GetIt.I<Mutation>().createQuestion(
        const QuestionSelector(), QuestionData(title: title, body: body));
  }

  Future<Question?> getQuestion(String id) async {
    return await GetIt.I<Query>()
        .question(const QuestionSelector(user: UserSelector()), id);
  }
}
