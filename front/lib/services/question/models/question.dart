import 'package:graphql_decorator/annotations.dart';
import 'package:tutlayt/services/user/user.model.dart';

part 'question.g.dart';

@QlEntity(name: 'question')
abstract class Question {
  @QlField()
  final String id;
  @QlField()
  final List<String> files;
  @QlField()
  final User user;
  @QlField()
  final String title;
  @QlField()
  final String body;

  const Question({
    required this.id,
    required this.files,
    required this.user,
    required this.title,
    required this.body,
  });

  @QlQuery()
  Question question(String id);
}
