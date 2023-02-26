import 'package:graphql_decorator/annotations.dart';

part 'credentials.g.dart';

@QlEntity(name: 'credentials')
abstract class Credentials {
  @QlField()
  final String username;
  @QlField()
  final String password;

  const Credentials({
    required this.username,
    required this.password,
  });
}
