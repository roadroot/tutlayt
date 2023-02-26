import 'package:graphql_decorator/annotations.dart';

part 'register.g.dart';

@QlEntity(name: 'register')
abstract class RegisterParam {
  @QlField()
  final String username;
  @QlField()
  final String email;
  @QlField()
  final String password;

  const RegisterParam({
    required this.username,
    required this.email,
    required this.password,
  });
}
